#pragma once
#include <error.hpp>
#include <utility.hpp>
#include <experimental/coroutine>
#include <intrin.h>
#include <new>
#include <type_traits>
#include <utility>
#include <cassert>

namespace detail {

template <typename T>
struct result_storage {
  template <typename... Args>
  constexpr result_storage(Args&&... args) noexcept : error(error::success)
  {
    new (static_cast<void*>(&value)) T(std::forward<Args>(args)...);
  }

  constexpr result_storage(error failure) noexcept : error(failure)
  {
    assert(failure != error::success);
  }

  constexpr result_storage(result_storage&& other) noexcept : error(other.error)
  {
    if (error == error::success) {
      new (static_cast<void*>(&value)) T(std::move(other.value));
    }
  }

  constexpr result_storage(const result_storage& other) noexcept : error(other.error)
  {
    if (error == error::success) {
      new (static_cast<void*>(&value)) T(other.value);
    }
  }

  constexpr result_storage& operator=(result_storage&& other) noexcept
  {
    if (error == error::success) {
      value.~T();
    }
    error = other.error;
    if (error == error::success) {
      new (static_cast<void*>(&value)) T(std::move(other.value));
    }
    return *this;
  }

  constexpr result_storage& operator=(const result_storage& other) noexcept
  {
    if (error == error::success) {
      value.~T();
    }
    error = other.error;
    if (error == error::success) {
      new (static_cast<void*>(&value)) T(other.value);
    }
    return *this;
  }

  ~result_storage()
  {
    if (error == error::success) {
      value.~T();
    }
  }

  template <typename... Args>
  constexpr void set(Args&&... args) noexcept
  {
    if (error == error::success) {
      value.~T();
    }
    error = error::success;
    new (static_cast<void*>(&value)) T(std::forward<Args>(args)...);
  }

  constexpr void set(error failure) noexcept
  {
    assert(failure != error::success);
    if (error == error::success) {
      value.~T();
    }
    error = failure;
  }

  error error;
  union {
    T value;
  };
};

}  // namespace detail

template <typename T>
class [[nodiscard]] result :
  private delete_move_constructor<T>,
  private delete_copy_constructor<T>,
  private delete_move_assignment<T>,
  private delete_copy_assignment<T>
{
public:
  using value_type = std::remove_cvref_t<T>;
  using error_type = error;

  struct promise_type {
    constexpr auto initial_suspend() const noexcept
    {
      return std::experimental::suspend_never{};
    }

    constexpr auto final_suspend() const noexcept
    {
      return std::experimental::suspend_never{};
    }

    result get_return_object() noexcept
    {
      return this;
    }

    template <typename... Args>
    constexpr void return_value(Args&&... args) noexcept
    {
      assert(result_ptr);
      assert(result_ptr->storage_.error == error::result_not_ready);
      result_ptr->storage_.set(std::forward<Args>(args)...);
    }

    constexpr void return_value(error_type error) noexcept
    {
      assert(result_ptr);
      assert(result_ptr->storage_.error == error::result_not_ready);
      result_ptr->storage_.set(error);
    }

#if defined(__clang__) || _HAS_EXCEPTIONS
    [[noreturn]] void unhandled_exception() const noexcept
    {
      std::abort();
    }
#endif

    result* result_ptr = nullptr;
  };

  // clang-format off

  [[gsl::suppress("26495")]] result(promise_type* promise) noexcept
#if !defined(NDEBUG) || defined(__INTELLISENSE__)
    : storage_(error::result_not_ready)
#endif
  {
    promise->result_ptr = this;
  }

  template <typename... Args, std::enable_if_t<std::is_constructible_v<value_type, Args&&...>>* = nullptr>
  constexpr result(Args&& ... args) noexcept : storage_(std::forward<Args>(args)...)
  {}

  constexpr result(error error) noexcept : storage_(error)
  {}

  result(result&& other) = default;
  result(const result& other) = default;
  result& operator=(result&& other) = default;
  result& operator=(const result& other) = default;

  // clang-format on

  constexpr explicit operator bool() const noexcept
  {
    return storage_.error == error::success;
  }

  constexpr value_type* operator->() noexcept
  {
    assert(storage_.error == error::success);
    return &storage_.value;
  }

  constexpr const value_type* operator->() const noexcept
  {
    assert(storage_.error == error::success);
    return &storage_.value;
  }

  constexpr value_type& operator*()& noexcept
  {
    assert(storage_.error == error::success);
    return storage_.value;
  }

  constexpr value_type&& operator*()&& noexcept
  {
    assert(storage_.error == error::success);
    return std::move(storage_).value;
  }

  constexpr const value_type& operator*() const& noexcept
  {
    assert(storage_.error == error::success);
    return storage_.value;
  }

  constexpr const value_type&& operator*() const&& noexcept
  {
    assert(storage_.error == error::success);
    return storage_.value;
  }

  constexpr value_type& value()& noexcept
  {
    assert(storage_.error == error::success);
    return storage_.value;
  }

  constexpr value_type&& value()&& noexcept
  {
    assert(storage_.error == error::success);
    return std::move(storage_).value;
  }

  constexpr const value_type& value() const& noexcept
  {
    assert(storage_.error == error::success);
    return storage_.value;
  }

  constexpr const value_type&& value() const&& noexcept
  {
    assert(storage_.error == error::success);
    return std::move(storage_).value;
  }

  constexpr error error() const noexcept
  {
    return storage_.error;
  }

  constexpr bool await_ready() const noexcept
  {
    return storage_.error == error::success;
  }

  template <typename Promise>
  bool await_suspend(std::experimental::coroutine_handle<Promise> handle) noexcept
  {
    assert(storage_.error != error::success);
#if !defined(NDEBUG)
    [[maybe_unused]] const auto message = to_string(storage_.error).data();
    __debugbreak();
#endif
    handle.promise().return_value(storage_.error);
    handle.destroy();
    return true;
  }

  constexpr value_type await_resume() noexcept
  {
    assert(storage_.error == error::success);
    return std::move(storage_).value;
  }

private:
  detail::result_storage<value_type> storage_;
};

template <>
class [[nodiscard]] result<void>
{
public:
  using value_type = void;
  using error_type = error;

  struct promise_type {
    constexpr auto initial_suspend() const noexcept
    {
      return std::experimental::suspend_never{};
    }

    constexpr auto final_suspend() const noexcept
    {
      return std::experimental::suspend_never{};
    }

    result get_return_object() noexcept
    {
      return this;
    }

    constexpr void return_value(error_type error) noexcept
    {
      assert(result_ptr);
      assert(result_ptr->error_ == error::result_not_ready);
      result_ptr->error_ = error;
    }

#if defined(__clang__) || _HAS_EXCEPTIONS
    [[noreturn]] void unhandled_exception() const noexcept
    {
      std::abort();
    }
#endif

    result* result_ptr = nullptr;
  };

  // clang-format off

  [[gsl::suppress("26495")]] result(promise_type* promise) noexcept
#if !defined(NDEBUG) || defined(__INTELLISENSE__)
    : error_(error::result_not_ready)
#endif
  {
    promise->result_ptr = this;
  }

  // clang-format on

  constexpr result() noexcept : error_(error::success)
  {}

  constexpr result(error_type error) noexcept : error_(error)
  {}

  constexpr explicit operator bool() const noexcept
  {
    return error_ == error::success;
  }

  constexpr value_type operator->() const noexcept
  {
    assert(error_ == error::success);
  }

  constexpr value_type operator*() const noexcept
  {
    assert(error_ == error::success);
  }

  constexpr value_type value() const noexcept
  {
    assert(error_ == error::success);
  }

  constexpr error_type error() const noexcept
  {
    return error_;
  }

  constexpr bool await_ready() const noexcept
  {
    return error_ == error::success;
  }

  template <typename Promise>
  bool await_suspend(std::experimental::coroutine_handle<Promise> handle) noexcept
  {
    assert(error_ != error::success);
#if !defined(NDEBUG)
    [[maybe_unused]] const auto message = to_string(error_).data();
    __debugbreak();
#endif
    handle.promise().return_value(error_);
    handle.destroy();
    return true;
  }

  constexpr void await_resume() const noexcept
  {
    assert(error_ == error::success);
  }

private:
  error_type error_;
};
