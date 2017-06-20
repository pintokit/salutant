class SubmissionsController < ApplicationController
  allow_cors :create
  before_action :set_submission, only: [:show, :edit, :update, :destroy]

  # GET /submissions
  def index
    @submissions = Submission.all
  end

  # GET /submissions/1
  def show
  end

  # GET /submissions/new
  def new
    @submission = Submission.new
  end

  # GET /submissions/1/edit
  def edit
  end

  # POST /submissions
  def create
    @submission = Submission.new(submission_params)
    @landing_page = request.headers['Origin']
    
    respond_to do |format|
      if @submission.save
        format.html { redirect_to @landing_page, notice: 'Submission was successfully created.' }
        format.json { render :show, status: :created, location: @submission }
      else
        format.html { render :new }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /submissions/1
  def update
    respond_to do |format|
      if @submission.update(submission_params)
        format.html { redirect_to @submission, notice: 'Submission was successfully updated.' }
        format.json { render :show, status: :ok, location: @submission }
      else
        format.html { render :edit }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1
  def destroy
    @submission.destroy
    respond_to do |format|
      format.html { redirect_to submissions_url, notice: 'Submission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submission
      @submission = Submission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def submission_params
      params.require(:submission).permit(:name, :email, :content, :body, :phone)
    end
end
