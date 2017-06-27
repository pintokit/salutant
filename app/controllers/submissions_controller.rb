class SubmissionsController < ApplicationController
  allow_cors :create
  before_action :parse_submission, only: :create
  before_action :set_submission, only: [:show, :edit, :update, :destroy]
  before_action :configure_spam_filter, only: :update

  # GET /submissions
  def index
    @submissions = Submission.all.order(:filter_result).reverse
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
    respond_to do |format|
      if @did_save
        FilterSpamJob.new(@submission, @http_headers).perform_now
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
        format.html { redirect_to @submission, notice: @submission_updated_notice }
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
    def parse_submission
      @submission = Submission.new(submission_params)
      @did_save = @submission.save

      @landing_page, @http_headers = request_submission_headers_from(request)
      @submission.update headers: @http_headers
    end

    def request_submission_headers_from(request)
      # Collect all CGI-style HTTP_ headers except cookies for privacy..
      headers = request.env.select { |k,v| k =~ /^HTTP_/ }.reject { |k,v| ['HTTP_COOKIE','HTTP_SENSITIVE'].include? k }

      landing_page = request.headers['Origin']
      return landing_page, headers
    end

    def set_submission
      @submission = Submission.find(params[:id])
    end

    def configure_spam_filter
      if params[:submission][:filter_result] != @submission.filter_result
        if params[:submission][:filter_result] == 'spam'
          SubmitSpamJob.new(@submission).perform_now
          @submission_updated_notice = 'Spam successfully reported.'
        elsif params[:submission][:filter_result] == 'not_spam'
          SubmitHamJob.new(@submission).perform_now
          @submission_updated_notice = 'False positives successfully reported.'
        end
      else
        @submission_updated_notice = 'Submission was successfully updated.'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def submission_params
      params.require(:submission).permit(:name, :email, :content, :body, :phone, :filter_result)
    end
end
