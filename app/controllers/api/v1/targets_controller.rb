class Api::V1::TargetsController < ApplicationController
  before_action :set_target, only: [:show, :destroy, :content]

  # GET /targets.json
  def index
    @targets = Target.all
    respond_to do |format|
      format.html { render json: @targets }
      format.json { render json: @targets }
    end
  end

  # GET /targets/1.json
  def show
    if @target
    respond_to do |format|
      format.html { render json: @target.as_json(include: [contents: { except: [:target_id, :created_at, :updated_at] }]) }
      format.json { render json: @target.as_json(include: [contents: { except: [:target_id, :created_at, :updated_at] }]) }
    end
    else @target
      render json: {errors: 'Target not found!'}, status: 404
    end
  end

  # GET /targets/1/content.json
  def content
    respond_to do |format|
      format.html { render json: @target.contents }
      format.json { render json: @target.contents }
    end
  end

  # POST /targets.json
  def create

    @target = Target.new(target_params)
    if valid_url?(@target.target_url)
      parse_url
      respond_to do |format|
        if @target.save
          format.html { render json: @target, status: :created }
          format.json { render json: @target, status: :created }
        else
          format.html { render json: @target.errors, status: :unprocessable_entity }
          format.json { render json: @target.errors, status: :unprocessable_entity }
        end
      end

    else
      respond_to do |format|
        format.html { render json: {errors: 'Invalid URL!'}, status: :unprocessable_entity }
        format.json { render json: {errors: 'Invalid URL!'}, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /targets/1.json
  def destroy
    if @target
    @target.destroy
    respond_to do |format|
      format.html { head :no_content }
      format.json { head :no_content }
    end
    else
      render json: {errors: 'Target not found!'}, status: 404
    end

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_target
    @target = Target.where(id: params[:id]).first
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def target_params
    params.require(:target).permit(:target_url)
  end

  SCHEMES = %w(http https)

  def valid_url?(target_url)
    parsed = Addressable::URI.parse(target_url) or return false
    SCHEMES.include?(parsed.scheme)
  end

  def parse_url
    doc = Nokogiri::HTML(open(@target.target_url))
    doc.css('a, h1, h2, h3').each do |el|
      @content = Content.new
      @content.target = @target
      @content.data_type = el.name
      if el.name == 'a'
        @content.data = el['href']
      else
        @content.data = el.content
      end
      @content.save!
    end
  end

end
