User.create(email: ENV['DEMO_EMAIL'], password: ENV['DEMO_PASSWORD'], confirmed_at: Time.now)

Submission.create(name: "Tim Brown", email: "designthinking@ideo.com", created_at: Time.now, content: {"body"=>"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "sent_to"=>:mazza })

Submission.create(name: "Guion Bluford", email: "bluford@nasa.com", created_at: "2017-09-25 23:57:52", content: {"body"=>"Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", "sent_to"=>:solis })

Submission.create(name: "Mae Jemison", email: "jemison@stanford.edu", created_at: "2017-09-23 23:57:52", content: {"body"=>"Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", "sent_to"=>:peaking })
