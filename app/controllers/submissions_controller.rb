class SubmissionsController < ApplicationController
  allow_cors :create
  before_action :parse_submission, only: :create
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
    respond_to do |format|
      if @did_save
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

    def parse_submission
      submission = Submission.new(submission_params)
      @did_save = submission.save
      @landing_page = request.headers['Origin']

      api_key = ENV['AKISMET_API_KEY']
      app_url = "http://#{ENV['APP_DOMAIN']}"
      http_headers = { 'User-Agent' => "Salutant/1.0 | #{ENV['AKISMET_VERSION']}", 'Content-Type' => 'application/x-www-form-urlencoded' }
      method_name = 'comment-check'

      uri = URI("https://#{api_key}.rest.akismet.com/1.1/#{method_name}")

      message = { blog: app_url, user_ip: request.remote_ip, user_agent: request.user_agent, referrer: request.referer, comment_type: 'contact-form', comment_author: submission.name, comment_author_email: submission.email, comment_content: submission.content, comment_date_gmt: submission.created_at, blog_lang: 'en', blog_charset: 'UTF-8' }

      post_parameters = URI.encode_www_form(message)

      response = Net::HTTP.start( uri.host, uri.port, use_ssl: :true) do |http|
        http.post(uri, post_parameters, http_headers)
      end

      case response
      when Net::HTTPRedirection
        print 'Failed to pull listings because the remote server issued a redirect'
      when Net::HTTPSuccess

        unless %w{ true false }.include?(response.body)
          print "#{response.error!}"
        end

        [ response.body == 'true', response['X-akismet-pro-tip'] == 'discard' ]

        if response.body == 'true'
          submission.update! filter_result: :spam
        else
          submission.update! filter_result: :not_spam
        end

      else # failed to receive response code 200
        print "#{response.error!}"
      end

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def submission_params
      params.require(:submission).permit(:name, :email, :content, :body, :phone, :filter_result)
    end
end
