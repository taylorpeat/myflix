shared_examples "require_sign_in" do
  it "redirects unauthenticated users to sign in page" do
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "require_admin" do
  it "redirects unauthenticated users to sign in page" do
    session[:user_id] = Fabricate(:user).id
    action
    expect(response).to redirect_to home_path
  end
end