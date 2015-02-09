class Api::DomainsCnamesController < ApiDomainController
  include Loginable
  before_action do
    @user = current_user
    @id = params[:id] unless params[:id].blank?
  end

  def index
    @cnames = getDomain.cnames
  end

  def show
    @cname = getDomain.cnames.find @id
  end

  def create
    begin
      getDomain.cnames.create! params.require(:domains_cname).permit(:name, :to_name)
      @success = true
    rescue
      @success = false
    end
  end

  def destroy
    @cname = getDomain.cnames.find @id
    begin
      @cname.destroy!
      @success = true
    rescue
      @success = false
    end
  end
end
