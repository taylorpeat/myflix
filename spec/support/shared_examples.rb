shared_examples "require_sign_in" do
  it "redirects unauthenticated users to sign in page" do
    action
    expect(response).to redirect_to sign_in_path
  end
end