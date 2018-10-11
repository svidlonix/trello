# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = Project.all
    respond_with(@projects)
  end

  def show
    @project = Project.find_by(id: params[:id])
    respond_with(@project)
  end
end
