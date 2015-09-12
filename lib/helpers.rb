module API
  module Helpers
    def json_error(r, code, message)
      error = {
        code: code,
        message: message
      }
      r.halt code, error
    end

    def record_not_found(r, params, fields=[:id])
      json_error(r, 404, "Record Not Found for given #{fields} => #{params}")
    end

    def invalid_params(r, fields)
      json_error(r, 422, "Invalid data for fields: #{fields.join(', ')}")
    end

    def delete_response(r)
      r.response.status = 204
      r.response.write(nil)
    end

    def rom
      ROM.env
    end
  end
end

