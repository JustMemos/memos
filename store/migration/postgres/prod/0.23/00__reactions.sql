UPDATE "reaction" SET "reaction_type" = '👍' WHERE "reaction_type" = 'THUMBS_UP';
UPDATE "reaction" SET "reaction_type" = '👎' WHERE "reaction_type" = 'THUMBS_DOWN';
UPDATE "reaction" SET "reaction_type" = '💛' WHERE "reaction_type" = 'HEART';
UPDATE "reaction" SET "reaction_type" = '🔥' WHERE "reaction_type" = 'FIRE';
UPDATE "reaction" SET "reaction_type" = '👏' WHERE "reaction_type" = 'CLAPPING_HANDS';
UPDATE "reaction" SET "reaction_type" = '😂' WHERE "reaction_type" = 'LAUGH';
UPDATE "reaction" SET "reaction_type" = '👌' WHERE "reaction_type" = 'OK_HAND';
UPDATE "reaction" SET "reaction_type" = '🚀' WHERE "reaction_type" = 'ROCKET';
UPDATE "reaction" SET "reaction_type" = '👀' WHERE "reaction_type" = 'EYES';
UPDATE "reaction" SET "reaction_type" = '🤔' WHERE "reaction_type" = 'THINKING_FACE';
UPDATE "reaction" SET "reaction_type" = '🤡' WHERE "reaction_type" = 'CLOWN_FACE';
UPDATE "reaction" SET "reaction_type" = '❓' WHERE "reaction_type" = 'QUESTION_MARK';

INSERT INTO "system_setting" ("name", "value", "description")
VALUES (
  'MEMO_RELATED',
  '{"contentLengthLimit":8192,"reactions":["👍","👎","💛","🔥","👏","😂","👌","🚀","👀","🤔","🤡","❓"]}',
  ''
)
ON CONFLICT("name") DO UPDATE
SET "value" =
  jsonb_set(
    "system_setting"."value"::jsonb,
    '{reactions}',
    '["👍","👎","💛","🔥","👏","😂","👌","🚀","👀","🤔","🤡","❓"]'::jsonb
  );

ALTER TABLE
  memo
ADD
  COLUMN nest INTEGER NOT NULL DEFAULT 0;

CREATE TABLE nest (
  id SERIAL PRIMARY KEY,
  uid TEXT NOT NULL,
  creator_id INTEGER NOT NULL,
  created_ts BIGINT NOT NULL DEFAULT EXTRACT(EPOCH FROM NOW()),
  updated_ts BIGINT NOT NULL DEFAULT EXTRACT(EPOCH FROM NOW()),
  row_status TEXT NOT NULL DEFAULT 'NORMAL'
);

INSERT INTO
  nest (uid, creator_id)
SELECT
  'Personal', id
FROM
  "user";