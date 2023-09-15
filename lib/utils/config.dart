const url = 'http://10.0.2.2:8082';

const auth = "$url/auth";
const login = "$auth/login";
const signup = "$auth/signup";

const user = "$url/user";
const getUserNameByEmail = "$user/get-username";
const addTask = "$user/add-activity";
const updateActivityStatus = "$user/update-activity-status";
const updateName = "$user/update-username";
const updatePassword = "$user/update-password";
const updateDaily = "$user/schedule-daily-update";
const deleteAccount = "$user/delete-account";
const deleteActivity = "$user/deleteTask";
