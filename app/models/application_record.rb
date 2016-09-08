class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

########## PROJ NOTES ##############
# TODO Build out search
# TODO Build update (should work only for one appt)
# TODO Build errors for misc bad requests
#   e.g. POST to specific appt
# http://www.restapitutorial.com/lessons/httpmethods.html
