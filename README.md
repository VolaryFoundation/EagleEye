MockingBird (Data Manipulation WebSite)
================

The server acts as a webpage for group and other feature's data storage. The system is a client of the Eagle server (https://github.com/VolaryFoundation/Eagle) 
You will need to hook up to a local eagle server to use this system. See read me on above repo link to help with setup.

Systems being used: Sinatra, SASS, MongoDB, HAML, Shotgun

Setup:
------
*Clone the code base from git hub*  
    `git clone git@github.com:VolaryFoundation/MockingBird-API.git`

*Change the Direcotry*
    `cd MockingBird-API`  
    
*Copy and update database yml file if personal env is needed*  
    `cp env.rb env_personal.rb`
    
*Load the ruby gems:*  
    `bundle install`
    
*create database* !IMPORTANT You most have Eagle running before performing this step  
    `rake db:seed`

*Load the server*  
    `shotgun`
    
*Notes:*  
The server default URL is: http://localhost:9393/  
Access the page through the root.


For Development
---------------
*Load SASS compiler watch function*  
    `sass --watch assets/widgets.scss:public/css/widgets.css`   

*Code Standards:*  
* HAML on html
* Strait javascript (No coffee script (Exception: Testing))  
* indent spacing (2 spaces)


For Testing
---------------
Unit test: Rspec
Intergration test: Rspec and Capybara


to run test: rake spec

##License

EagleEye is Copyright 2014 Volary Foundation and Contributors  

EagleEye is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

EagleEye is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along with EagleEye.  If not, see <http://www.gnu.org/licenses/>.

