require 'spec_helper'

describe 'GET /api/v1/employees/:id' do

  it 'should return an employee by its id' do
    employee = Employee.create(first_name: "Jill", last_name: "Smith", email: "jsmith@example.net", office_phone: "555-555-5555", job_title: "Software Engineer")

    get "/api/v1/employees/#{employee.id}.json"

    expect(response_json).to eq(
      {
        'id' => employee.id,
        'first_name' => employee.first_name,
        'last_name' => employee.last_name,
        'email' => employee.email,
        'job_title' => employee.job_title,
        'office_phone' => employee.office_phone
      }
    )
  end

  it 'should return a status code of 404 if employee is not found' do

    get "/api/v1/employees/9999.json"

    expect(response.status).to eq(404)
  end
  
end

describe 'GET /api/v1/employees' do

  it 'should return all employees' do
    employee_1 = Employee.create(first_name: "Jill", last_name: "Smith", email: "jsmith@example.net", office_phone: "555-555-5555", job_title: "Software Engineer")
    employee_2 = Employee.create(first_name: "John", last_name: "Davidson", email: "jdavidson@example.net", office_phone: "555-555-5556", job_title: "Software Engineer")

    get "/api/v1/employees.json"

    expect(response_json).to eq(
      [
        {
          'id' => employee_1.id,
          'first_name' => employee_1.first_name,
          'last_name' => employee_1.last_name,
          'email' => employee_1.email,
          'job_title' => employee_1.job_title,
          'office_phone' => employee_1.office_phone
        },
        {
          'id' => employee_2.id,
          'first_name' => employee_2.first_name,
          'last_name' => employee_2.last_name,
          'email' => employee_2.email,
          'job_title' => employee_2.job_title,
          'office_phone' => employee_2.office_phone
        }
      ]
    )
  end

end

describe 'POST /api/v1/employees' do

  it 'should create new employee and save first name, last name, email, office phone, and job title' do
    
    post 'api/v1/employees.json', {
      employee: {
        first_name: "Abigail",
        last_name: "Adams",
        email: "aadams@example.net",
        office_phone: "555-123-4567",
        job_title: "President"
      }
    }.to_json, {'Content-Type' => 'application/json'}

    employee = Employee.last

    expect(employee.first_name).to eq("Abigail")
    expect(employee.last_name).to eq("Adams")
    expect(employee.email).to eq("aadams@example.net")
    expect(employee.office_phone).to eq("555-123-4567")
    expect(employee.job_title).to eq("President")
  end

  it 'should render id' do
    post 'api/v1/employees.json', {
      employee: {
        first_name: "Abigail",
        last_name: "Adams",
        email: "aadams@example.net",
        office_phone: "555-123-4567",
        job_title: "President"
      }
    }.to_json, {'Content-Type' => 'application/json'}

    expect(response_json).to eq({'id' => Employee.last.id})
  end

  it 'should return error message when invalid' do
    post 'api/v1/employees.json', {
      employee: {
        first_name: "Abigail",
        last_name: "Adams",
        office_phone: "555-123-4567",
        job_title: "President"
      }
    }.to_json, {'Content-Type' => 'application/json'}

    expect(response_json).to eq({
      "message" => "Employee not created",
      "errors" => ["Email can't be blank"]
    })
  end

end

describe 'PATCH /api/v1/employees/:id' do

  it 'should update attributes of employee with given id' do
    employee = Employee.create(first_name: "Jill", last_name: "Smith", email: "jsmith@example.net", office_phone: "555-555-5555", job_title: "Software Engineer")

    patch "api/v1/employees/#{employee.id}.json", {
      employee: { office_phone: "555-999-9999" }
    }.to_json, {'Content-Type' => 'application/json'}

    employee.reload
    expect(employee.office_phone).to eq("555-999-9999")
  end

  it 'should render id' do
    employee = Employee.create(first_name: "Jill", last_name: "Smith", email: "jsmith@example.net", office_phone: "555-555-5555", job_title: "Software Engineer")

    patch "api/v1/employees/#{employee.id}.json", {
      employee: { office_phone: "555-999-9999" }
    }.to_json, {'Content-Type' => 'application/json'}

    expect(response_json).to eq({'id' => Employee.last.id})
  end

  it 'should return error message when invalid' do
    employee = Employee.create(first_name: "Jill", last_name: "Smith", email: "jsmith@example.net", office_phone: "555-555-5555", job_title: "Software Engineer")

    patch "api/v1/employees/#{employee.id}.json", {
      employee: { email: "" }
    }.to_json, {'Content-Type' => 'application/json'}

    expect(response_json).to eq({
      "message" => "Employee not modified",
      "errors" => ["Email can't be blank"]
    })
  end

  it 'should return a status code of 404 if employee is not found' do

    employee = Employee.create(first_name: "Jill", last_name: "Smith", email: "jsmith@example.net", office_phone: "555-555-5555", job_title: "Software Engineer")

    patch "api/v1/employees/9999.json", {
      employee: { office_phone: "555-999-9999" }
    }.to_json, {'Content-Type' => 'application/json'}

    expect(response.status).to eq(404)
  end

end

describe 'DELETE /api/v1/employees/:id' do
  it 'should delete employee' do
    employee = Employee.create(first_name: "Jill", last_name: "Smith", email: "jsmith@example.net", office_phone: "555-555-5555", job_title: "Software Engineer")

    delete "api/v1/employees/#{employee.id}.json"
    
    expect(Employee.find_by(id: employee.id)).to be_nil
  end

  it 'should return a status code of 404 if employee is not found' do
    employee = Employee.create(first_name: "Jill", last_name: "Smith", email: "jsmith@example.net", office_phone: "555-555-5555", job_title: "Software Engineer")

    delete "api/v1/employees/9999.json"

    expect(response.status).to eq(404)
  end
end
