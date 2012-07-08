include ApplicationHelper

def heading_and_title(heading, title)
  it { should have_selector('title', text: full_title(title)) }
  it { should have_selector('h1', text: heading) }
end