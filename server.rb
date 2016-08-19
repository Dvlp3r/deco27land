require 'sinatra'
require 'pony'



#Why/how do i add visuals to this page?

# get '/' do			#get methods takes two argumetns string: website
# 	p "#{Time.now}"	#block of ruby code executed when
# end

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end


post '/send' do 
  configure_pony
  first_name = params[:first_name]
  last_name = params [:last_name]
  sender_email = params[:email]
  message = params[:message]
  logger.error params.inspect
  begin
    Pony.mail(
      :from => "#{first_name} #{last_name}<#{sender_email}>",
      :to => 'luis@dvlper.com',
      :subject =>"#{first_name} #{last_name} is Requesting a Consultation",
      :body => "#{first_name} #{last_name}, #{sender_email}, #{message}",
    )
    redirect 'http://www.deco27.net/'
  rescue
    @exception = $!
    erb :boom
  end
end


def configure_pony
  Pony.options = {
    :via => :smtp,
    :via_options => { 
      :address              => 'smtp.sendgrid.net', 
      :port                 => '587',  
      :user_name            => ENV['SENDGRID_USERNAME'], 
      :password             => ENV['SENDGRID_PASSWORD'], 
      :authentication       => :plain, 
      :enable_starttls_auto => true,
      :domain               => 'heroku.com'
    }    
  }
end