class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

########## PROJ NOTES ##############
# TODO Build out search
# TODO Build errors for misc bad requests
#   e.g. POST to specific appt
# TODO Test thoroughly on heroku
# TODO Make sure hours work correctly
# http://www.restapitutorial.com/lessons/httpmethods.html
