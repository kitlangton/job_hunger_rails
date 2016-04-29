class JobsController < ApplicationController
  before_action :authenticate_user!
  wrap_parameters format: [:json]

  def create_from_chrome
    company = Company.find_or_create_by(name: params[:company_name],
                                        user_id: current_user.id)
    @job = Job.create(title: params[:title],
                      company_id: company.id,
                      application_status: 'Interested',
                      notes: params[:notes])

    respond_to do |f|
      if @job.save
        f.json { render json: 201 }
      else
        f.json { render :json => { :error_message => @job.errors.full_messages }, :status => :unprocessable_entity }

      end
    end
  end
end
