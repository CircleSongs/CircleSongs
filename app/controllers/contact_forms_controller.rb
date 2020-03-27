class ContactFormsController < ApplicationController
  def new
    @contact_form = ContactForm.new
    render :new
  end

  # rubocop:disable Metrics/MethodLength
  def create
    @contact_form = ContactForm.new(contact_form_params)
    @contact_form.request = request
    if @contact_form.spam?
      flash[:success] = t('.success')
      redirect_to new_contact_form_path
    elsif @contact_form.valid?
      @contact_form.deliver
      flash[:success] = t('.success')
      redirect_to new_contact_form_path
    else
      flash.now[:error] = 'Please correct the errors below'
      render :new
    end
  end

  private

  def contact_form_params
    params.require(:contact_form).permit(
      :name,
      :email,
      :subject,
      :message,
      :nickname
    )
  end
end
