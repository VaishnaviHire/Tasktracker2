import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

function init() {
 
 $(".start-button").click(addStartTimer);
  update_buttons();
}


function addStartTimer(e) {
  
  let startBtn = $(e.target);
  let task_id = startBtn.data("task-id");
  let user_id = startBtn.data("user-id");
  let time  =startBtn.data("time");
  let block_id = startBtn.data("block-id")
  if(block_id!="") {
    updateTimeBlock(block_id, time, user_id, task_id)

  }
  else {
    enterTimeBlock(task_id, user_id, time, "")
}
}


function enterTimeBlock(task_id, user_id, time, end_time) {
  let jsonStart = JSON.stringify({
   blocks: {
      task_id:task_id,
      user_id:user_id,
      start_time:time,
      end_time:end_time
    },
  });
  $.ajax(blocks_path, {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset= UTF-8",
    data:jsonStart,
    success: (resp) => {set_button(user_id, task_id, resp.data.id);}
  });

}

function updateTimeBlock(block_id, time, user_id, task_id) {
  let jsonStart = JSON.stringify({
    blocks: {
      end_time:time
    },
  });
  $.ajax(blocks_path + "/" + block_id, {
    method: "patch",
    dataType: "json",
    contentType: "application/json; charset= UTF-8",
    data:jsonStart,
    success: (resp) => {set_button(user_id, task_id, "");}
  });

}

function set_button(user_id, task_id, value) {
  $('.start-button').each( (_, bb) => {
    console.log(user_id)
    console.log(task_id)
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



$(".edit-btn").click(function(e){
  let Btn = $(e.target);
  let block_id = Btn.data("block-id")
  let start_time = Btn.data("start-time")
  let end_time = Btn.data("end-time")
  start_time =  new Date (start_time);
  end_time = new Date (end_time);
  $("#editBlock_start_time_year").val(start_time.getFullYear())
  $("#editBlock_start_time_month").val(start_time.getMonth() + 1)
  $("#editBlock_start_time_day").val(start_time.getDate())
  $("#editBlock_start_time_hour").val(start_time.getHours())
  $("#editBlock_start_time_minute").val(start_time.getMinutes())
  
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
				$("#editBlock_start_time_minuite").val());


   let edit_end_time = new Date ( $("#editBlock_end_time_year").val(),
                                 $("#editBlock_end_time_month").val(), 
                                $("#editBlock_end_time_day").val(), 
                                $("#editBlock_end_time_hour").val(),
                                $("#editBlock_end_time_minute").val());

  
 
  let edit_task_id = $("#edit_task_id").val()
  let edit_user_id = $("#edit_user_id").val()
  let edit_block_id = $("#edit_block_id").val()
 
  let jsonStart = JSON.stringify({
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
    data:jsonStart,
    success: () => { alert('Timeblock Updated') ? "" : location.reload(); },
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
