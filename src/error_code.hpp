#pragma once
#include <error.hpp>
#include <string>
#include <type_traits>

inline std::error_code make_error_code(error e)
{
  struct codes : std::error_category {
    const char* name() const noexcept override
    {
      return "error";
    }

    std::string message(int ev) const override
    {
      switch (static_cast<error>(ev)) {
      default:
        [[fallthrough]];

      case error::failure:
        return "failure";

      case error::result_not_ready:
        return "result not ready";
      }
    }

    std::error_condition default_error_condition(int ev) const noexcept override
    {
      switch (static_cast<error>(ev)) {
      default:
        return { ev, *this };

      case error::failure:
        return condition::general_error;

      case error::result_not_ready:
        return condition::result_error;
      }
    }
  };

  static const codes cat{};
  return std::error_code{ static_cast<std::underlying_type<error>::type>(e), cat };
}

inline std::error_condition make_error_condition(condition c)
{
  struct codes : std::error_category {
    const char* name() const noexcept override
    {
      return "error";
    }

    std::string message(int cv) const override
    {
      switch (static_cast<condition>(cv)) {
      default:
        [[fallthrough]];

      case condition::general_error:
        return "A general error occurred";

      case condition::result_error:
        return "An result value was accessed while not ready";
      }
    }
  };

  static const codes cat{};
  return std::error_condition{ static_cast<std::underlying_type<condition>::type>(c), cat };
}
