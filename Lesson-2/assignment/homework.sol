pragma solidity ^0.4.0;

contract Payroll {
  struct Employee {
    address id;
    uint salary;
    uint lastPayday;
  }

  uint constant payDuration = 10 seconds;
  uint totalSalary;

  address owner;
  Employee[] employees;

  function Payroll() {
    owner = msg.sender;
  }

  function addFund() payable returns (uint) {
    return address(this).balance;
  }

  function getFund() returns (uint) {
    return address(this).balance;
  }
  function calculateRunaway() returns (uint) {
    return address(this).balance / totalSalary;
  }
  // 对员工操作
  function addEmployee(address id, uint salary) {
    require(msg.sender == owner);
    var (e, index) = _findEmployee(id);
    assert(e.id == 0x0);
    employees.push(Employee(id, salary, now));
    totalSalary += salary;
  }
  function removeEmployee(address id) {
    require(msg.sender == owner);
    var (e, index) = _findEmployee(id);
    assert(e.id != 0x0);
    _partialPaid(e);
    delete employees[index];
    totalSalary -= e.salary;

    employees[index] = employees[employees.length - 1];
    employees.length --;
  }
  function updateEmployee(address id, uint salary) {
    require(msg.sender == owner);

    salary *= 1 ether;
    var (e, index) = _findEmployee(id);
    assert(e.id != 0x0);
    _partialPaid(e);

    totalSalary -= e.salary;
    totalSalary += salary;
    employees[index].salary = salary;
    employees[index].lastPayday = now;
  }

  function _partialPaid(Employee e) private {
    uint payment = e.salary * (now - e.lastPayday) / payDuration;
    e.id.transfer(payment);
  }
  function _findEmployee(address id) private returns (Employee, uint) {
    for (uint i = 0; i < employees.length; i++) {
      if (employees[i].id == id) {
        return (employees[i], i);
      }
    }
  }

}
