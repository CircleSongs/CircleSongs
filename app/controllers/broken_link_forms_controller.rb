class BrokenLinkFormsController < ApplicationController
  def create
    @broken_link_form = BrokenLinkForm.new(broken_link_form_params)
    @broken_link_form.request = request
    if @broken_link_form.valid? || @broken_link_form.spam?
      @broken_link_form.deliver

      render json: { message: t('.success') }, status: :ok
    else
      render json: { message: t('.error') }, status: :not_modified
    end
  end

  private

  def broken_link_form_params
    params.require(:broken_link_form).permit(
      :recording_id,
      :nickname
    )
  end
end
