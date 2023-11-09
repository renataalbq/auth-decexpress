describe User do 
    it "é válido quando email está presente" do 
     user = User.new( name: 'Renata', 
      email: 'renataalb@email.com' ) 
      
      expect(user).to be_valid 
     end 
   end