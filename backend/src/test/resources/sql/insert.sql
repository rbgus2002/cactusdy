-- user
INSERT INTO `user` (user_id, create_date, modified_date, activate_date, delete_yn, email, name, nickname, phone_model, picture, status_message) VALUES (1, '2023-09-04 21:05:34.061086', '2023-09-04 21:05:34.061086', '2023-09-04 21:05:34.021249', 'N', 'rbgus2002@naver.com', '최규현', '규규', 'string', 'string', '');
INSERT INTO `user` (user_id, create_date, modified_date, activate_date, delete_yn, email, name, nickname, phone_model, picture, status_message) VALUES (2, '2023-09-04 21:05:51.310402', '2023-09-04 21:05:51.310402', '2023-09-04 21:05:51.309612', 'N', 'arkady@naver.com', '장재우', 'arkady', 'string', 'string', '');
INSERT INTO `user` (user_id, create_date, modified_date, activate_date, delete_yn, email, name, nickname, phone_model, picture, status_message) VALUES (3, '2023-09-04 21:05:51.310402', '2023-09-04 21:05:51.310402', '2023-09-04 21:05:51.309612', 'N', 'are_you_hungry@question.com', '홍예지', '찡찡이', 'string', 'string', '');

-- study
INSERT INTO study (study_id, create_date, modified_date, delete_yn, detail, invite_qr_code, invite_link, picture, study_name, user_id) VALUES (1, '2023-09-04 21:06:28.140570', '2023-09-04 21:06:28.140570', 'N', '화이팅', 'not yet', 'not yet', 'string', '알고리즘스터디', 1);

-- notice
INSERT INTO notice (notice_id, create_date, modified_date, contents, delete_yn, pin_yn, title, study_id, user_id) VALUES (1, '2023-09-07 00:09:20.247088', '2023-09-07 00:10:34.784027', '상세내용1', 'N', 'N', '공지사항1', 1, 1);
INSERT INTO notice (notice_id, create_date, modified_date, contents, delete_yn, pin_yn, title, study_id, user_id) VALUES (2, '2023-09-08 00:09:20.247088', '2023-09-08 00:10:34.784027', '상세내용2', 'N', 'N', '공지사항2', 1, 1);
INSERT INTO notice (notice_id, create_date, modified_date, contents, delete_yn, pin_yn, title, study_id, user_id) VALUES (3, '2023-09-09 00:09:20.247088', '2023-09-09 00:10:34.784027', '상세내용3', 'N', 'N', '공지사항3', 1, 1);
INSERT INTO notice (notice_id, create_date, modified_date, contents, delete_yn, pin_yn, title, study_id, user_id) VALUES (4, '2023-09-10 00:09:20.247088', '2023-09-10 00:10:34.784027', '상세내용4', 'N', 'N', '공지사항4', 1, 1);

-- comment
INSERT INTO comment (comment_id, create_date, modified_date, contents, delete_yn, notice_id, parent_comment_id, user_id) VALUES (1, '2023-09-04 21:08:38.757307', '2023-09-04 21:08:38.757307', '댓글1', 'N', 1, null, 1);
INSERT INTO comment (comment_id, create_date, modified_date, contents, delete_yn, notice_id, parent_comment_id, user_id) VALUES (3, '2023-09-04 21:08:38.757307', '2023-09-04 21:08:38.757307', '대댓글1', 'N', 1, 1, 1);
INSERT INTO comment (comment_id, create_date, modified_date, contents, delete_yn, notice_id, parent_comment_id, user_id) VALUES (4, '2023-09-04 21:08:38.757307', '2023-09-04 21:08:38.757307', '대댓글2', 'N', 1, 1, 1);

INSERT INTO comment (comment_id, create_date, modified_date, contents, delete_yn, notice_id, parent_comment_id, user_id) VALUES (2, '2023-09-04 21:08:38.757307', '2023-09-04 21:08:38.757307', '댓글2', 'N', 1, null, 1);

-- round
INSERT INTO round (round_id, create_date, modified_date, study_place, study_time, delete_yn, detail, study_id) VALUES (1, '2023-09-04 21:07:57.208247', '2023-09-06 23:02:09.487730', null, null, 'N', 'detail', 1);
-- INSERT INTO round (round_id, create_date, modified_date, study_place, study_time, delete_yn, detail, study_id) VALUES (1, '2023-09-04 21:07:57.208247', '2023-09-06 23:02:09.487730', null, '2023-09-11 12:07:00', 'N', '오늘도 규현이와 예지누나가 숙제를 안해왔다. 뒤졌다 진짜.이제 앞으로는 안해온 사람이 밥사기로 결정하였다. 근데 벌써부터 다음주에 얻어먹을 것 같은 기분이다. 다음주부터는 시험기간', 1);

