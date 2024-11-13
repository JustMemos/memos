UPDATE `reaction` SET `reaction_type` = '👍' WHERE `reaction_type` = 'THUMBS_UP';
UPDATE `reaction` SET `reaction_type` = '👎' WHERE `reaction_type` = 'THUMBS_DOWN';
UPDATE `reaction` SET `reaction_type` = '💛' WHERE `reaction_type` = 'HEART';
UPDATE `reaction` SET `reaction_type` = '🔥' WHERE `reaction_type` = 'FIRE';
UPDATE `reaction` SET `reaction_type` = '👏' WHERE `reaction_type` = 'CLAPPING_HANDS';
UPDATE `reaction` SET `reaction_type` = '😂' WHERE `reaction_type` = 'LAUGH';
UPDATE `reaction` SET `reaction_type` = '👌' WHERE `reaction_type` = 'OK_HAND';
UPDATE `reaction` SET `reaction_type` = '🚀' WHERE `reaction_type` = 'ROCKET';
UPDATE `reaction` SET `reaction_type` = '👀' WHERE `reaction_type` = 'EYES';
UPDATE `reaction` SET `reaction_type` = '🤔' WHERE `reaction_type` = 'THINKING_FACE';
UPDATE `reaction` SET `reaction_type` = '🤡' WHERE `reaction_type` = 'CLOWN_FACE';
UPDATE `reaction` SET `reaction_type` = '❓' WHERE `reaction_type` = 'QUESTION_MARK';

INSERT INTO `system_setting` (`name`, `value`, `description`)
VALUES (
  'MEMO_RELATED',
  '{"contentLengthLimit":8192,"reactions":["👍","👎","💛","🔥","👏","😂","👌","🚀","👀","🤔","🤡","❓"]}',
  ''
)
ON CONFLICT(name) DO UPDATE
SET value =
  json_set(
    value,
    '$.reactions',
    json_array('👍', '👎', '💛', '🔥', '👏', '😂', '👌', '🚀', '👀', '🤔', '🤡', '❓')
  );

ALTER TABLE
  memo
ADD
  COLUMN nest INTEGER NOT NULL DEFAULT 0;

CREATE TABLE nest (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  uid TEXT NOT NULL,
  creator_id INTEGER NOT NULL,
  created_ts BIGINT NOT NULL DEFAULT (strftime('%s', 'now')),
  updated_ts BIGINT NOT NULL DEFAULT (strftime('%s', 'now')),
  row_status TEXT NOT NULL CHECK (row_status IN ('NORMAL', 'ARCHIVED')) DEFAULT 'NORMAL'
);

INSERT INTO
  nest (uid, creator_id)
SELECT
  'Personal', id
FROM
  user;