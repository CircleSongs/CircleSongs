class ContactFormsController < ApplicationController
  def new
    @contact_form = ContactForm.new
    render :new
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create
    @contact_form = ContactForm.new(contact_form_params)
    @contact_form.request = request
    if @contact_form.spam?
      flash[:success] = t(".success")
      redirect_to new_contact_form_path
    elsif @contact_form.valid?
      @contact_form.deliver
      flash[:success] = t(".success")
      redirect_to songs_path
    else
      flash.now[:error] = t(".error")
      render :new
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private
    def contact_form_params
      params.expect(
        contact_form: %i[name
                         email
                         subject
                         message
                         nickname]
      )
    end
end
