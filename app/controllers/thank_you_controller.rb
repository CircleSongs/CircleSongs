class ThankYouController < ApplicationController
  def donation
    redirect_to root_path, notice: t(".")
  end

  def purchase
    redirect_to root_path, notice: t(".")
  end
end
