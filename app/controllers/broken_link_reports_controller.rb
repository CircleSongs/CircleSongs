class BrokenLinkReportsController < ApplicationController
  def create
    @broken_link_report = BrokenLinkReport.new(params[:broken_link_report])
    @recording = @broken_link_report.recording
    @broken_link_report.deliver
    @recording.update! reported: true
  end
end

