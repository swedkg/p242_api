require 'test_helper'

class UserModelTest < ActiveSupport::TestCase
  
  #validate first name
  test "validate first name is blank" do
    user = User.new(firstName: '')
    user.valid?    
    assert user.errors.added?(:firstName, :blank)
    assert user.errors.added?(:firstName, "Your first name cannot be blank")
  end

  test "validate first name is too short" do
    user = User.new(firstName: "ab")
    user.valid?
    assert user.errors.added?(:firstName, :too_short, {count: 3})
    assert user.errors.added?(:firstName, "Your first name is too short.")
  end

  test "validate first name is too long" do
    user = User.new(firstName: "12345678901234567890123")
    user.valid?
    assert user.errors.added?(:firstName, :too_long, {count: 20})
    assert user.errors.added?(:firstName, "Your first name is too long (20 characters max).")
  end

  #validate last name
  test "validate last name is blank" do
    user = User.new(lastName: '')
    user.valid?    
    assert user.errors.added?(:lastName, :blank)
    assert user.errors.added?(:lastName, "Your last name cannot be blank")
  end

  test "validate last name is too short" do
    user = User.new(lastName: "ab")
    user.valid?
    assert user.errors.added?(:lastName, :too_short, {count: 3})
    assert user.errors.added?(:lastName, "Your last name is too short.")
  end

  test "validate last name is too long" do
    user = User.new(lastName: "1234567890123456789012345678901234567890123")
    user.valid?
    assert user.errors.added?(:lastName, :too_long, {count: 40})
    assert user.errors.added?(:lastName, "Your last name is too long (40 characters max).")
  end

  #validate email
  test "validate email is blank" do
    user = User.new(email: '')
    user.valid?    
    assert user.errors.added?(:email, :blank)
    assert user.errors.added?(:email, "The email is required")
  end

  test "validate email uniqueness" do
    user = User.new(email: "test@example.com")
    user.valid?
    assert user.errors.added?(:email, :taken, {value: "test@example.com"})
    assert user.errors.added?(:email, "This email is already in use")
  end

  test "validate email format" do
    user = User.new(email: "@ds.com")
    # puts "user:", user
    user.valid?
    # puts erros: user.errors
    assert user.errors.added?(:email, :invalid, {value: "@ds.com"})
    assert user.errors.added?(:email, "The email is invalid")
  end

end
