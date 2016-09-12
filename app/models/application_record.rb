class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

########## PROJ NOTES ##############
# TODO Build errors for misc bad requests
#   e.g. POST to specific appt
# TODO Test thoroughly on heroku
# http://www.restapitutorial.com/lessons/httpmethods.html
