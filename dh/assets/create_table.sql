create table if not exists public.challenge (
    email text not null, 
    condition bigint, 
    primary key (email)
);