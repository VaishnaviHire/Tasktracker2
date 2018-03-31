import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

function init() {
 
 $(".start-button").click(addBlockTime);
  update_buttons();
}


function addBlockTime(e) {
  
  let start_button = $(e.target);
  let task_id = start_button.data("task-id");
  let user_id = start_button.data("user-id");
  let time  = start_button.data("time");
  let block_id = start_button.data("block-id")
// add new block
  if(block_id=="") {
     let time_block = JSON.stringify({
   blocks: {
      task_id:task_id,
      user_id:user_id,
      start_time:new Date(),
      end_time:""
    },
  });
  $.ajax(blocks_path, {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset= UTF-8",
    data:time_block,
    success: (resp) => {set_button(user_id, task_id, resp.data.id);}
  });
  }
//update existing block
  else {
     let time_block = JSON.stringify({
    blocks: {
      end_time:new Date()
    },
  });
  $.ajax(blocks_path + "/" + block_id, {
    method: "patch",
    dataType: "json",
    contentType: "application/json; charset= UTF-8",
    data:time_block,
    success: (resp) => {set_button(user_id, task_id, "");}
  });


    
}
}



function set_button(user_id, task_id, value) {
  $('.start-button').each( (_, bb) => {
  
    if (task_id == $(bb).data('task-id')) {
      $(bb).data('block-id', value)
    }
  });
  update_buttons();
}

function update_buttons() {
  $('.start-button').each( (_, bb) => {
    
    let block_id = $(bb).data('block-id');
    if (block_id == "") {
      
      $(bb).text("Start Working");
    }
    else {
   
      $(bb).text("Stop Working");
    }
  });
}



$(".edit-timeblock").click(function(e){
  let Btn = $(e.target);
  let block_id = Btn.data("block-id")
  let start_time = Btn.data("start-time")
  
  let end_time = Btn.data("end-time")
  console.log(start_time)
  console.log(end_time)
  console.log("hfjd")
 
  end_time = new Date (end_time);
  start_time = new Date();
 console.log(start_time)
 console.log(start_time.getFullYear())

  
  
/// Value of end time

 $("#editBlock_end_time_year").val(end_time.getFullYear())
  $("#editBlock_end_time_month").val(end_time.getMonth() + 1)
  $("#editBlock_end_time_day").val(end_time.getDate())
  $("#editBlock_end_time_hour").val(end_time.getHours())
  $("#editBlock_end_time_minute").val(end_time.getMinutes())
  $("#form-container").css("display", "block")
  $("#edit_block_id").attr("value", block_id)
  
});



$("#edit_form").click(function(e){
 
  let edit_start_time = new Date ( $("#editBlock_start_time_year").val(),
                                 $("#editBlock_start_time_month").val(),
 				$("#editBlock_start_time_day").val(),
 				$("#editBlock_start_time_hour").val(),
				$("#editBlock_start_time_minute").val());


   let edit_end_time = new Date ( $("#editBlock_end_time_year").val(),
                                 $("#editBlock_end_time_month").val(), 
                                $("#editBlock_end_time_day").val(), 
                                $("#editBlock_end_time_hour").val(),
                                $("#editBlock_end_time_minute").val());

  
 
  let edit_task_id = $("#edit_task_id").val()
  let edit_user_id = $("#edit_user_id").val()
  let edit_block_id = $("#edit_block_id").val()
 
  let time_block = JSON.stringify({
    blocks: {
      task_id:edit_task_id,
      user_id:edit_user_id,
      start_time:edit_start_time,
      end_time:edit_end_time
    },
  });
  
  $.ajax(blocks_path + "/" + edit_block_id, {
    method: "patch",
    dataType: "json",
    contentType: "application/json; charset= UTF-8",
    data:time_block,
    success: () => { alert('Time Block Updated') ? "" : location.reload(); },
  });

});



$(".delete-timeblock").click(function(e){
  let deletebtn = $(e.target);
  let block_id = deletebtn.data("block-id")
  $.ajax(blocks_path + "/" + block_id, {
   method: "delete",
   dataType: "json",
   contentType: "application/json; charset=UTF-8",
   data: "",
   success: () => { alert('Time Block Deleted') ? "" : location.reload(); },
 });
});



$(init)
