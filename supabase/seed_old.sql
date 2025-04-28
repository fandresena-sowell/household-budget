SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."audit_log_entries" ("instance_id", "id", "payload", "created_at", "ip_address") VALUES
	('00000000-0000-0000-0000-000000000000', '55575451-8a38-47ec-ade7-fa07ec469349', '{"action":"user_confirmation_requested","actor_id":"ab66ca04-412d-4d1f-a39a-2a7f15b24f4e","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}', '2025-04-26 10:39:22.622671+00', ''),
	('00000000-0000-0000-0000-000000000000', '2eebbbec-741a-42b6-a1c2-155e562121d8', '{"action":"user_signedup","actor_id":"ab66ca04-412d-4d1f-a39a-2a7f15b24f4e","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"team"}', '2025-04-26 10:39:50.740042+00', ''),
	('00000000-0000-0000-0000-000000000000', '37e507a6-ab5e-4eca-8929-45d17598c623', '{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"ryoichifandry@gmail.com","user_id":"ab66ca04-412d-4d1f-a39a-2a7f15b24f4e","user_phone":""}}', '2025-04-26 10:49:45.773971+00', ''),
	('00000000-0000-0000-0000-000000000000', '4657846b-5eb5-4299-8364-fa2c5074c8d2', '{"action":"user_signedup","actor_id":"f23f4af6-f007-4854-aa1d-50730ded66b9","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2025-04-26 10:51:16.211868+00', ''),
	('00000000-0000-0000-0000-000000000000', '66e5b97a-dab3-48d0-99be-9befe8a61a68', '{"action":"login","actor_id":"f23f4af6-f007-4854-aa1d-50730ded66b9","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-26 10:51:16.216848+00', ''),
	('00000000-0000-0000-0000-000000000000', 'cdd3cf68-a028-46a9-8406-5c65cd82e959', '{"action":"login","actor_id":"f23f4af6-f007-4854-aa1d-50730ded66b9","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-26 10:51:16.609061+00', ''),
	('00000000-0000-0000-0000-000000000000', '0dc59f43-2ee5-4fac-a627-6ced29fd909d', '{"action":"logout","actor_id":"f23f4af6-f007-4854-aa1d-50730ded66b9","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account"}', '2025-04-26 10:54:14.769935+00', ''),
	('00000000-0000-0000-0000-000000000000', '13d6a37a-4add-483b-ae14-daa3ea7124db', '{"action":"login","actor_id":"f23f4af6-f007-4854-aa1d-50730ded66b9","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-26 10:54:34.288272+00', ''),
	('00000000-0000-0000-0000-000000000000', '08c2a0dc-3090-4723-b017-c4097cb27ba8', '{"action":"logout","actor_id":"f23f4af6-f007-4854-aa1d-50730ded66b9","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account"}', '2025-04-26 11:01:27.666516+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a662105a-2ad0-4e5d-b706-3dee927d45bf', '{"action":"login","actor_id":"f23f4af6-f007-4854-aa1d-50730ded66b9","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-26 11:01:46.802814+00', ''),
	('00000000-0000-0000-0000-000000000000', '7c21a665-4f47-4cd9-bb65-e9695e443f00', '{"action":"logout","actor_id":"f23f4af6-f007-4854-aa1d-50730ded66b9","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account"}', '2025-04-26 11:21:23.451752+00', ''),
	('00000000-0000-0000-0000-000000000000', '96cf9fbe-1ee2-4e2a-a476-e1a4c534a4b7', '{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"ryoichifandry@gmail.com","user_id":"f23f4af6-f007-4854-aa1d-50730ded66b9","user_phone":""}}', '2025-04-26 11:21:36.772695+00', ''),
	('00000000-0000-0000-0000-000000000000', '4bd38414-3552-446d-b2fb-727dcce471a9', '{"action":"user_signedup","actor_id":"5b7e8055-3136-42db-8a6d-0ed0a34085f9","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2025-04-26 11:22:32.443798+00', ''),
	('00000000-0000-0000-0000-000000000000', '2a8fdb5d-4fd5-487b-92ac-b3ea4d80fd63', '{"action":"login","actor_id":"5b7e8055-3136-42db-8a6d-0ed0a34085f9","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-26 11:22:32.447919+00', ''),
	('00000000-0000-0000-0000-000000000000', 'c11e4a6e-0b25-4762-8796-cc84b8922ef2', '{"action":"login","actor_id":"5b7e8055-3136-42db-8a6d-0ed0a34085f9","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-26 11:22:33.276041+00', ''),
	('00000000-0000-0000-0000-000000000000', '11952745-94ad-45e0-bfe1-ade3da4f49a8', '{"action":"logout","actor_id":"5b7e8055-3136-42db-8a6d-0ed0a34085f9","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account"}', '2025-04-26 11:24:44.321032+00', ''),
	('00000000-0000-0000-0000-000000000000', '23dd7a1b-a5f9-48e0-8059-b8346cd57a40', '{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"ryoichifandry@gmail.com","user_id":"5b7e8055-3136-42db-8a6d-0ed0a34085f9","user_phone":""}}', '2025-04-26 11:25:40.673238+00', ''),
	('00000000-0000-0000-0000-000000000000', '2ea615eb-e7ee-4f18-a1a3-38ae6716ca9d', '{"action":"user_signedup","actor_id":"7f391dd8-0c4b-4c4d-bbe9-941959e59a34","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2025-04-26 11:26:39.881425+00', ''),
	('00000000-0000-0000-0000-000000000000', '54e2f84d-caff-4ee1-9ba1-cddc93988a3a', '{"action":"login","actor_id":"7f391dd8-0c4b-4c4d-bbe9-941959e59a34","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-26 11:26:39.885593+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f7cb5a66-e5e1-4697-ac0d-5000bd424859', '{"action":"login","actor_id":"7f391dd8-0c4b-4c4d-bbe9-941959e59a34","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-26 11:26:40.275378+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e089a376-8645-4a48-a203-2b8acb38761f', '{"action":"logout","actor_id":"7f391dd8-0c4b-4c4d-bbe9-941959e59a34","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account"}', '2025-04-26 11:26:47.164428+00', ''),
	('00000000-0000-0000-0000-000000000000', '50c00614-59be-423f-af6f-2df9c8a8d45d', '{"action":"user_signedup","actor_id":"a0d37bfe-015d-479c-9b2e-7f90893c3e19","actor_username":"velotsihoarana@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2025-04-26 11:27:18.44944+00', ''),
	('00000000-0000-0000-0000-000000000000', 'eea9f518-b429-46ab-8b0e-fab29fd2e76c', '{"action":"login","actor_id":"a0d37bfe-015d-479c-9b2e-7f90893c3e19","actor_username":"velotsihoarana@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-26 11:27:18.453314+00', ''),
	('00000000-0000-0000-0000-000000000000', '442fae49-ae91-4839-9a1a-4c0ab982dd5b', '{"action":"login","actor_id":"a0d37bfe-015d-479c-9b2e-7f90893c3e19","actor_username":"velotsihoarana@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-26 11:27:18.879698+00', ''),
	('00000000-0000-0000-0000-000000000000', '5e0bb80f-f4ff-4af9-b01f-93c9ed5ae1e5', '{"action":"logout","actor_id":"a0d37bfe-015d-479c-9b2e-7f90893c3e19","actor_username":"velotsihoarana@gmail.com","actor_via_sso":false,"log_type":"account"}', '2025-04-26 11:40:52.95229+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f8270d8a-9afb-49fd-83a4-a14770bf34b9', '{"action":"login","actor_id":"7f391dd8-0c4b-4c4d-bbe9-941959e59a34","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-26 11:54:35.597709+00', ''),
	('00000000-0000-0000-0000-000000000000', '06408fbb-4cf6-4c25-b3db-df207077052c', '{"action":"logout","actor_id":"7f391dd8-0c4b-4c4d-bbe9-941959e59a34","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account"}', '2025-04-26 11:58:02.423247+00', ''),
	('00000000-0000-0000-0000-000000000000', '988fe3de-5acd-41e2-86f0-c7d0f7af1cbd', '{"action":"login","actor_id":"7f391dd8-0c4b-4c4d-bbe9-941959e59a34","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-26 11:58:25.456762+00', ''),
	('00000000-0000-0000-0000-000000000000', '9c551316-1120-4b74-96e0-dc19edcbd61e', '{"action":"logout","actor_id":"7f391dd8-0c4b-4c4d-bbe9-941959e59a34","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account"}', '2025-04-26 12:14:07.797656+00', ''),
	('00000000-0000-0000-0000-000000000000', '2480107f-82e2-444c-a52d-b40c85e7611a', '{"action":"login","actor_id":"7f391dd8-0c4b-4c4d-bbe9-941959e59a34","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-26 12:14:28.25169+00', ''),
	('00000000-0000-0000-0000-000000000000', '0f459fb0-7b18-45f3-9549-5049d5213ee7', '{"action":"login","actor_id":"7f391dd8-0c4b-4c4d-bbe9-941959e59a34","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-26 12:47:28.30032+00', ''),
	('00000000-0000-0000-0000-000000000000', '17f43e41-f97b-4cd3-95a0-0e0218c492bb', '{"action":"logout","actor_id":"7f391dd8-0c4b-4c4d-bbe9-941959e59a34","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account"}', '2025-04-26 13:11:17.044362+00', ''),
	('00000000-0000-0000-0000-000000000000', '1c0b4775-280d-4c2c-a9da-94b8df512b07', '{"action":"login","actor_id":"a0d37bfe-015d-479c-9b2e-7f90893c3e19","actor_username":"velotsihoarana@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-26 13:11:34.817416+00', ''),
	('00000000-0000-0000-0000-000000000000', 'f8586e2b-dee0-4319-a900-6227e42a77f8', '{"action":"login","actor_id":"7f391dd8-0c4b-4c4d-bbe9-941959e59a34","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-26 13:34:05.945715+00', ''),
	('00000000-0000-0000-0000-000000000000', '44f8ae81-ec41-4a6f-978d-5a5264a68b57', '{"action":"logout","actor_id":"7f391dd8-0c4b-4c4d-bbe9-941959e59a34","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account"}', '2025-04-26 13:35:18.809674+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e101f75c-7063-4571-b7a1-d976d689fbbf', '{"action":"token_refreshed","actor_id":"a0d37bfe-015d-479c-9b2e-7f90893c3e19","actor_username":"velotsihoarana@gmail.com","actor_via_sso":false,"log_type":"token"}', '2025-04-26 15:33:41.024443+00', ''),
	('00000000-0000-0000-0000-000000000000', '3153c32d-7274-4712-a9c8-b8a9be969472', '{"action":"token_revoked","actor_id":"a0d37bfe-015d-479c-9b2e-7f90893c3e19","actor_username":"velotsihoarana@gmail.com","actor_via_sso":false,"log_type":"token"}', '2025-04-26 15:33:41.025777+00', ''),
	('00000000-0000-0000-0000-000000000000', '46e95ac2-bdf9-4b8d-bbb2-fc829edcd389', '{"action":"logout","actor_id":"a0d37bfe-015d-479c-9b2e-7f90893c3e19","actor_username":"velotsihoarana@gmail.com","actor_via_sso":false,"log_type":"account"}', '2025-04-26 15:33:42.866473+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e75b2906-c688-4067-86dc-03049918d0ea', '{"action":"login","actor_id":"7f391dd8-0c4b-4c4d-bbe9-941959e59a34","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-26 16:39:29.600074+00', '');


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at", "is_anonymous") VALUES
	('00000000-0000-0000-0000-000000000000', 'a0d37bfe-015d-479c-9b2e-7f90893c3e19', 'authenticated', 'authenticated', 'velotsihoarana@gmail.com', '$2a$10$6yMUby.HYHg9WYhXQIu0zeMoYGEH8.q2god0stQ6Ym7ha0Ze0bnxO', '2025-04-26 11:27:18.449941+00', NULL, '', NULL, '', NULL, '', '', NULL, '2025-04-26 13:11:34.818184+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "a0d37bfe-015d-479c-9b2e-7f90893c3e19", "email": "velotsihoarana@gmail.com", "last_name": "VELO", "first_name": "Tandrify", "email_verified": true, "phone_verified": false}', NULL, '2025-04-26 11:27:18.443063+00', '2025-04-26 15:33:41.029167+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'authenticated', 'authenticated', 'ryoichifandry@gmail.com', '$2a$10$bKLf1hSAGq.AxToFZl3qz.ptkBIyiwtyQpj6Xlg6p8V/qBdThdJde', '2025-04-26 11:26:39.881917+00', NULL, '', NULL, '', NULL, '', '', NULL, '2025-04-26 16:39:29.601043+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "7f391dd8-0c4b-4c4d-bbe9-941959e59a34", "email": "ryoichifandry@gmail.com", "last_name": "RANDRIA", "first_name": "Fandresena", "email_verified": true, "phone_verified": false}', NULL, '2025-04-26 11:26:39.873378+00', '2025-04-26 16:39:29.604454+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") VALUES
	('7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '{"sub": "7f391dd8-0c4b-4c4d-bbe9-941959e59a34", "email": "ryoichifandry@gmail.com", "last_name": "RANDRIA", "first_name": "Fandresena", "email_verified": false, "phone_verified": false}', 'email', '2025-04-26 11:26:39.878849+00', '2025-04-26 11:26:39.87891+00', '2025-04-26 11:26:39.87891+00', 'c300d38e-fa09-4f3d-b8f7-04b86d8b2e60'),
	('a0d37bfe-015d-479c-9b2e-7f90893c3e19', 'a0d37bfe-015d-479c-9b2e-7f90893c3e19', '{"sub": "a0d37bfe-015d-479c-9b2e-7f90893c3e19", "email": "velotsihoarana@gmail.com", "last_name": "VELO", "first_name": "Tandrify", "email_verified": false, "phone_verified": false}', 'email', '2025-04-26 11:27:18.445477+00', '2025-04-26 11:27:18.44552+00', '2025-04-26 11:27:18.44552+00', '88062cc3-3199-403e-bbc1-61f4a1914585');


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."sessions" ("id", "user_id", "created_at", "updated_at", "factor_id", "aal", "not_after", "refreshed_at", "user_agent", "ip", "tag") VALUES
	('c9a97ca1-04bb-46c4-aee9-2d5ccd1ffab3', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '2025-04-26 16:39:29.60112+00', '2025-04-26 16:39:29.60112+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', '129.222.109.69', NULL);


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."mfa_amr_claims" ("session_id", "created_at", "updated_at", "authentication_method", "id") VALUES
	('c9a97ca1-04bb-46c4-aee9-2d5ccd1ffab3', '2025-04-26 16:39:29.605048+00', '2025-04-26 16:39:29.605048+00', 'password', '07a8c2c2-2fac-4638-a06d-b58aa860db6c');


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."refresh_tokens" ("instance_id", "id", "token", "user_id", "revoked", "created_at", "updated_at", "parent", "session_id") VALUES
	('00000000-0000-0000-0000-000000000000', 19, '2oodj2auz6tc', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', false, '2025-04-26 16:39:29.602263+00', '2025-04-26 16:39:29.602263+00', NULL, 'c9a97ca1-04bb-46c4-aee9-2d5ccd1ffab3');


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: account_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."account_types" ("id", "name") VALUES
	('2a0fe853-284f-443c-9c19-01492f290292', 'Cash'),
	('80e1beb4-1e0c-4a3f-906b-4c53afd9f3cb', 'Credit Card'),
	('f2774f6b-3841-420b-ae9a-40ae88c154dc', 'Bank Deposit'),
	('0a057f88-4337-428e-91b7-717c42e7b10b', 'Loan');


--
-- Data for Name: households; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."households" ("id", "name", "created_at") VALUES
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', 'Fandresena''s Household', '2025-04-26 11:26:40.615325+00');


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."accounts" ("id", "household_id", "created_by_user_id", "name", "account_type_id", "initial_balance", "initial_balance_date", "created_at") VALUES
	('4133bd1a-ff26-404a-8157-f9ad30d1b759', '4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'Fandresena''s Account', '2a0fe853-284f-443c-9c19-01492f290292', 5000.00, '2025-04-26 11:48:58.935383+00', '2025-04-26 11:48:58.935383+00'),
	('13cbdb66-f000-40c8-82fd-5bab02481321', '4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'Tandrify''s Account', 'f2774f6b-3841-420b-ae9a-40ae88c154dc', 1000.00, '2025-04-26 11:49:10.135977+00', '2025-04-26 11:49:10.135977+00');


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: household_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."household_members" ("household_id", "user_id", "role", "joined_at") VALUES
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'owner', '2025-04-26 11:26:40.615325+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', 'a0d37bfe-015d-479c-9b2e-7f90893c3e19', 'member', '2025-04-26 11:27:19.207884+00');


--
-- Data for Name: todos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."todos" ("id", "created_at", "content") VALUES
	(1, '2025-04-26 07:39:10.137766+00', 'Todo 1'),
	(2, '2025-04-26 07:39:20.808141+00', 'Todo 2');


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."users" ("id", "email", "first_name", "last_name", "avatar_url", "created_at", "updated_at") VALUES
	('7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'ryoichifandry@gmail.com', 'Fandresena', 'RANDRIA', NULL, '2025-04-26 11:26:39.873034+00', '2025-04-26 11:26:39.873034+00'),
	('a0d37bfe-015d-479c-9b2e-7f90893c3e19', 'velotsihoarana@gmail.com', 'Tandrify', 'VELO', NULL, '2025-04-26 11:27:18.442742+00', '2025-04-26 11:27:18.442742+00');


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--



--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 19, true);


--
-- Name: todos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."todos_id_seq"', 2, true);


--
-- PostgreSQL database dump complete
--

RESET ALL;
