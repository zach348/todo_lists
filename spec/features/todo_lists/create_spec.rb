require 'spec_helper'
require 'pry'

describe "Creating todo lists" do
  def create_todo_list(options={})
    options[:title] ||= "my todo list"
    options[:decription] ||= "This is my todo list."

    visit "/todo_lists"
    click_link "New Todo list"
    expect(page).to have_content("New Todo List")
    fill_in "Title", with: options[:title]
    fill_in "Description", with: options[:description]
    click_button "Create Todo list"
  end
  it "redirects to the todo list index page on success" do
    visit "/todo_lists"
    click_link "New Todo list"
    expect(page).to have_content("New Todo List")
  end

  it "displays error when todo list has no title" do
    expect(TodoList.count).to eq(0)
    create_todo_list({title: "", description: "This is what I'm doing today"})
    expect(page).to have_content("error")
    expect(TodoList.count).to eq(0)
    visit "/todo_lists"
    expect(page).to_not have_content("This is what I'm doing today")
  end

  it "displays error when todo list has a title with less than 3 characters" do
    expect(TodoList.count).to eq(0)
    create_todo_list({title: "12", description: "This is what I'm doing today"})
    expect(page).to have_content("error")
    expect(TodoList.count).to eq(0)
    visit "/todo_lists"
    expect(page).to_not have_content("This is what I'm doing today")
  end

  it "displays error when todo list has no description" do
    expect(TodoList.count).to eq(0)
    create_todo_list({description: ""})
    expect(page).to have_content("error")
    expect(TodoList.count).to eq(0)
  end

  it "displays error when todo list description is less than 3 characters" do
    expect(TodoList.count).to eq(0)
    create_todo_list({title: "Hi", description: "12"})
    expect(page).to have_content("error")
    expect(TodoList.count).to eq(0)
    visit "/todo_lists"
    expect(page).to_not have_content("Hi")
  end
end
