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
  name = params[:name]
  sender_email = params[:email]
  sender_number = params[:telephone]
  message = params[:message]
  logger.error params.inspect
  begin
    Pony.mail(
      :from => "#{name}<#{sender_email}>",
      :to => 'fabian@deco27.net',
      :subject =>"#{name} is Requesting a Consultation",
      :body => "#{name}, #{sender_email}, #{sender_number}, #{message}",
    )
    redirect '/success.html'
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