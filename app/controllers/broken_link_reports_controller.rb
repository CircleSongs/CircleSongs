class BrokenLinkReportsController < ApplicationController
  def create
    @broken_link_report = BrokenLinkReport.new(params[:broken_link_report])
    @broken_link_report.notify
    @recording = @broken_link_report.recording
    @recording.update! reported: true
  end
end

