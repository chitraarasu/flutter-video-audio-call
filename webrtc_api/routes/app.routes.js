const meetingController = require("../controllers/meeting.controller");

const express = require("express");
const router = express.Router();

router.post("/meeting/start", meetingController.startMeeting);
router.get("/meeting/join", meetingController.chechMeetingExists);

router.get("/meeting/get", meetingController.getAllMeetingUsers);

module.exports = router;
