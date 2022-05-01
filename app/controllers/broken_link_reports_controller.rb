class BrokenLinkReportsController < ApplicationController
  def create
    broken_link_report = BrokenLinkReport.new(params[:broken_link_report])
    recording = broken_link_report.recording
    broken_link_report.deliver

    if recording.update reported: true
      redirect_to recording.song, notice: "Broken link reported, thank you!"
    else
      redirect_to recording.song, notice: "There was an issue.", status: :unprocessable_entity
    end
  end
end
