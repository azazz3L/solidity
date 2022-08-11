// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;


contract TodoList {

   struct ToDo{
        string text;
        bool completed;
   }

   ToDo[] public todos;

   function create(string calldata _text) external {

       ToDo memory todo = ToDo(_text,false);
       todos.push(todo);

   }

   function update(string calldata _text, bool _status, uint _index) external{

       ToDo storage todo = todos[_index];

       todo.text = _text;
       todo.completed = _status;
   }


}