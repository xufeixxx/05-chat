-- this file is use for postgresql database initialization

-- create user table
create table if not exists users {
    id bigserial primary key,
    fullname varchar(64) not null,
    email varchar(64) not null,
    -- hashed argon2 password
    password varchar(64) not null,
    created_at timestamp default current_timestamp,
};

-- create index of users for email
create unique index if not exists email_index on users(email);

-- create chat type: single, group, private_channel, public_channel
create type chat_type as enum ('single', 'group', 'private_channel', 'public_channel');

-- create chat table
create table if not exists chats {
    id bigserial primary key,
    name varchar(128) not null unique,
    type chat_type not null,
    -- user id list
    members bigint[] not null,
    created_at timestamp default current_timestamp,
};

--create message table
create table if not exists messages {
    id bigserial primary key,
    chat_id bigint not null,
    sender_id bigint not null,
    content text not null,
    images text[],
    created_at timestamp default current_timestamp,

    foreign key (chat_id) references chats(id),
    foreign key (sender_id) references users(id),
};

-- create index for messages for chat_id and created_at order by created_at desc
create index if not exists chat_id_created_at_index on messages(chat_id, created_at desc);

-- create index for messages for sender_id
create index if not exists sender_id_index on messages(sender_id);
