class ErrorsController < ApplicationController
  ADDRESSED_ERROR_CODE = ["404", "422", "500"]

  def show
    code = /#{ADDRESSED_ERROR_CODE.join("|")}/.match(request.path)[0]
    code = ADDRESSED_ERROR_CODE.include?(code) ? code.to_i : 500
    render action: code, status: code
  end
end
