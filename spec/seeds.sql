TRUNCATE TABLE users RESTART IDENTITY CASCADE;

INSERT INTO users (name, email, username, password) VALUES ('Simon Smith', 'simon@test.com', 'user_simon', 'simon123');
INSERT INTO users (name, email, username, password) VALUES ('Mary Jones', 'mary@test.com', 'user_mary', 'mary123');
INSERT INTO users (name, email, username, password) VALUES ('Wendy McGreggor', 'wendy@test.com', 'user_wendy', 'wendy123');

TRUNCATE TABLE peeps RESTART IDENTITY;

INSERT INTO peeps (timestamp, content, user_id) VALUES ('2022-11-04 12:41:50 +0000', 'A peep with some content', 1);
INSERT INTO peeps (timestamp, content, user_id) VALUES ('2022-01-02 18:30:10 +0000', 'A peep with some more content', 1);
INSERT INTO peeps (timestamp, content, user_id) VALUES ('2022-01-02 19:30:15 +0000', 'A peep with some different content', 1);
INSERT INTO peeps (timestamp, content, user_id) VALUES ('2022-01-02 14:00:05 +0000', 'A peep with some similar content', 2);
INSERT INTO peeps (timestamp, content, user_id) VALUES ('2022-01-02 16:10:00 +0000', 'Another peep with some content', 2);
INSERT INTO peeps (timestamp, content, user_id) VALUES ('2022-01-03 19:35:00 +0000', 'Another peep with some more content', 2);
INSERT INTO peeps (timestamp, content, user_id) VALUES ('2022-01-02 08:30:02 +0000', 'Another peep with some different content', 3);
INSERT INTO peeps (timestamp, content, user_id) VALUES ('2022-01-02 18:30:00 +0000', 'Another peep with some similar content', 3);