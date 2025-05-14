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
	('00000000-0000-0000-0000-000000000000', 'e75b2906-c688-4067-86dc-03049918d0ea', '{"action":"login","actor_id":"7f391dd8-0c4b-4c4d-bbe9-941959e59a34","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-26 16:39:29.600074+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e4e66bf7-6509-48ea-8209-6eb783143ab4', '{"action":"user_signedup","actor_id":"557da302-4fe3-4f77-a6f8-89b4a876af70","actor_username":"test.user@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2025-04-28 15:20:58.102262+00', ''),
	('00000000-0000-0000-0000-000000000000', '4979cee3-9867-48f7-84c4-f78c59c75137', '{"action":"login","actor_id":"557da302-4fe3-4f77-a6f8-89b4a876af70","actor_username":"test.user@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-28 15:20:58.108034+00', ''),
	('00000000-0000-0000-0000-000000000000', '88048676-6202-4dd8-aced-de9db2124772', '{"action":"login","actor_id":"557da302-4fe3-4f77-a6f8-89b4a876af70","actor_username":"test.user@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-28 15:20:58.29946+00', ''),
	('00000000-0000-0000-0000-000000000000', '9897c00e-a23a-453c-886d-bc98b7e71f55', '{"action":"logout","actor_id":"557da302-4fe3-4f77-a6f8-89b4a876af70","actor_username":"test.user@gmail.com","actor_via_sso":false,"log_type":"account"}', '2025-04-28 15:21:00.797413+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ab3f2f76-8ccf-47bf-9fee-2e8f9c3243ba', '{"action":"user_signedup","actor_id":"27a9b73e-dd53-4f7a-81d0-a4b64e6ca080","actor_username":"valisoa.randria@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2025-04-28 15:22:09.312918+00', ''),
	('00000000-0000-0000-0000-000000000000', 'a6c29c64-48ce-4b6b-aa8b-00c132891ca7', '{"action":"login","actor_id":"27a9b73e-dd53-4f7a-81d0-a4b64e6ca080","actor_username":"valisoa.randria@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-28 15:22:09.319431+00', ''),
	('00000000-0000-0000-0000-000000000000', 'ed1ec99a-0b3c-4790-aba0-a8d95beb3bf2', '{"action":"login","actor_id":"27a9b73e-dd53-4f7a-81d0-a4b64e6ca080","actor_username":"valisoa.randria@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-28 15:22:09.471647+00', ''),
	('00000000-0000-0000-0000-000000000000', '84cc5153-45ee-406e-87ba-38629f73afd0', '{"action":"logout","actor_id":"27a9b73e-dd53-4f7a-81d0-a4b64e6ca080","actor_username":"valisoa.randria@gmail.com","actor_via_sso":false,"log_type":"account"}', '2025-04-28 15:22:23.3347+00', ''),
	('00000000-0000-0000-0000-000000000000', '3b67e538-edc9-4498-928c-1d94d4e156e2', '{"action":"user_signedup","actor_id":"e7a235e2-a8f7-41e4-864d-35883693c029","actor_username":"test2.user@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2025-04-28 15:22:44.141128+00', ''),
	('00000000-0000-0000-0000-000000000000', '4d77b2d6-8cad-45ea-998b-0da1a4f0b585', '{"action":"login","actor_id":"e7a235e2-a8f7-41e4-864d-35883693c029","actor_username":"test2.user@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-28 15:22:44.146743+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b7a5b7fb-6fb4-4ae1-ae0d-f632739bc3cb', '{"action":"login","actor_id":"e7a235e2-a8f7-41e4-864d-35883693c029","actor_username":"test2.user@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-28 15:22:44.285988+00', ''),
	('00000000-0000-0000-0000-000000000000', '31d44ffe-004e-4e04-ac91-41940f7fe514', '{"action":"logout","actor_id":"e7a235e2-a8f7-41e4-864d-35883693c029","actor_username":"test2.user@gmail.com","actor_via_sso":false,"log_type":"account"}', '2025-04-28 15:30:54.312559+00', ''),
	('00000000-0000-0000-0000-000000000000', 'fe08faab-f2e1-4d0b-9c81-1cddb1b22279', '{"action":"login","actor_id":"7f391dd8-0c4b-4c4d-bbe9-941959e59a34","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2025-04-28 15:31:04.71576+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e3b2bafa-09ac-45ed-9a51-70825f1ee122', '{"action":"logout","actor_id":"7f391dd8-0c4b-4c4d-bbe9-941959e59a34","actor_username":"ryoichifandry@gmail.com","actor_via_sso":false,"log_type":"account"}', '2025-04-28 15:36:13.656514+00', '');


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at", "is_anonymous") VALUES
	('00000000-0000-0000-0000-000000000000', 'a0d37bfe-015d-479c-9b2e-7f90893c3e19', 'authenticated', 'authenticated', 'velotsihoarana@gmail.com', '$2a$10$6yMUby.HYHg9WYhXQIu0zeMoYGEH8.q2god0stQ6Ym7ha0Ze0bnxO', '2025-04-26 11:27:18.449941+00', NULL, '', NULL, '', NULL, '', '', NULL, '2025-04-26 13:11:34.818184+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "a0d37bfe-015d-479c-9b2e-7f90893c3e19", "email": "velotsihoarana@gmail.com", "last_name": "VELO", "first_name": "Tandrify", "email_verified": true, "phone_verified": false}', NULL, '2025-04-26 11:27:18.443063+00', '2025-04-26 15:33:41.029167+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '27a9b73e-dd53-4f7a-81d0-a4b64e6ca080', 'authenticated', 'authenticated', 'valisoa.randria@gmail.com', '$2a$10$fyI9CIcscrAvKuiZQpMXluWtQiwxDfbO.5OTTD2Rk6M0bJUd3AaPy', '2025-04-28 15:22:09.31426+00', NULL, '', NULL, '', NULL, '', '', NULL, '2025-04-28 15:22:09.473197+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "27a9b73e-dd53-4f7a-81d0-a4b64e6ca080", "email": "valisoa.randria@gmail.com", "last_name": "RANDRIA", "first_name": "Valisoa", "email_verified": true, "phone_verified": false, "target_household_id": "4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c"}', NULL, '2025-04-28 15:22:09.303365+00', '2025-04-28 15:22:09.476152+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'authenticated', 'authenticated', 'test.user@gmail.com', '$2a$10$ptoH5oY5IAthMcE3CiK3pOlkOaQCoWqnvTcskbqZJiIwKtzjmYbXa', '2025-04-28 15:20:58.103401+00', NULL, '', NULL, '', NULL, '', '', NULL, '2025-04-28 15:20:58.300757+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "557da302-4fe3-4f77-a6f8-89b4a876af70", "email": "test.user@gmail.com", "last_name": "USER", "first_name": "Test", "email_verified": true, "phone_verified": false}', NULL, '2025-04-28 15:20:58.080901+00', '2025-04-28 15:20:58.303577+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', 'e7a235e2-a8f7-41e4-864d-35883693c029', 'authenticated', 'authenticated', 'test2.user@gmail.com', '$2a$10$U2WErAywtlLZdhjNFmAgs.vBoxM07HW2jwtYHDPYo7SsISfcCEhYu', '2025-04-28 15:22:44.137177+00', NULL, '', NULL, '', NULL, '', '', NULL, '2025-04-28 15:22:44.287721+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "e7a235e2-a8f7-41e4-864d-35883693c029", "email": "test2.user@gmail.com", "last_name": "USER", "first_name": "Test2", "email_verified": true, "phone_verified": false, "target_household_id": "e8796342-268d-4018-8ac4-b81e3ae4f975"}', NULL, '2025-04-28 15:22:44.132377+00', '2025-04-28 15:22:44.291394+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'authenticated', 'authenticated', 'ryoichifandry@gmail.com', '$2a$10$bKLf1hSAGq.AxToFZl3qz.ptkBIyiwtyQpj6Xlg6p8V/qBdThdJde', '2025-04-26 11:26:39.873034+00', NULL, '', NULL, '', NULL, '', '', NULL, '2025-04-28 15:31:04.717532+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "7f391dd8-0c4b-4c4d-bbe9-941959e59a34", "email": "ryoichifandry@gmail.com", "last_name": "RANDRIA", "first_name": "Fandresena", "email_verified": true, "phone_verified": false}', NULL, '2025-04-26 11:26:39.873034+00', '2025-04-28 15:31:04.721152+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") VALUES
	('7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '{"sub": "7f391dd8-0c4b-4c4d-bbe9-941959e59a34", "email": "ryoichifandry@gmail.com", "last_name": "RANDRIA", "first_name": "Fandresena", "email_verified": false, "phone_verified": false}', 'email', '2025-04-26 11:26:39.878849+00', '2025-04-26 11:26:39.87891+00', '2025-04-26 11:26:39.87891+00', 'c300d38e-fa09-4f3d-b8f7-04b86d8b2e60'),
	('a0d37bfe-015d-479c-9b2e-7f90893c3e19', 'a0d37bfe-015d-479c-9b2e-7f90893c3e19', '{"sub": "a0d37bfe-015d-479c-9b2e-7f90893c3e19", "email": "velotsihoarana@gmail.com", "last_name": "VELO", "first_name": "Tandrify", "email_verified": false, "phone_verified": false}', 'email', '2025-04-26 11:27:18.445477+00', '2025-04-26 11:27:18.44552+00', '2025-04-26 11:27:18.44552+00', '88062cc3-3199-403e-bbc1-61f4a1914585'),
	('557da302-4fe3-4f77-a6f8-89b4a876af70', '557da302-4fe3-4f77-a6f8-89b4a876af70', '{"sub": "557da302-4fe3-4f77-a6f8-89b4a876af70", "email": "test.user@gmail.com", "last_name": "USER", "first_name": "Test", "email_verified": false, "phone_verified": false}', 'email', '2025-04-28 15:20:58.096957+00', '2025-04-28 15:20:58.096994+00', '2025-04-28 15:20:58.096994+00', 'df15844d-b4aa-4268-821b-b346f24aee06'),
	('27a9b73e-dd53-4f7a-81d0-a4b64e6ca080', '27a9b73e-dd53-4f7a-81d0-a4b64e6ca080', '{"sub": "27a9b73e-dd53-4f7a-81d0-a4b64e6ca080", "email": "valisoa.randria@gmail.com", "last_name": "RANDRIA", "first_name": "Valisoa", "email_verified": false, "phone_verified": false, "target_household_id": "4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c"}', 'email', '2025-04-28 15:22:09.309689+00', '2025-04-28 15:22:09.309762+00', '2025-04-28 15:22:09.309762+00', '01780210-7f35-47d4-b5af-7c5b2e7588e0'),
	('e7a235e2-a8f7-41e4-864d-35883693c029', 'e7a235e2-a8f7-41e4-864d-35883693c029', '{"sub": "e7a235e2-a8f7-41e4-864d-35883693c029", "email": "test2.user@gmail.com", "last_name": "USER", "first_name": "Test2", "email_verified": false, "phone_verified": false, "target_household_id": "e8796342-268d-4018-8ac4-b81e3ae4f975"}', 'email', '2025-04-28 15:22:44.137177+00', '2025-04-28 15:22:44.137231+00', '2025-04-28 15:22:44.137231+00', 'b6c8e417-4e0b-4442-b944-03ae220c2721');


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



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
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', 'Fandresena''s Household', '2025-04-26 11:26:40.615325+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', 'Test''s Household', '2025-04-28 15:20:58.080035+00');


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."accounts" ("id", "household_id", "created_by_user_id", "name", "account_type_id", "initial_balance", "initial_balance_date", "created_at") VALUES
	('4133bd1a-ff26-404a-8157-f9ad30d1b759', '4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'Fandresena''s Account', '2a0fe853-284f-443c-9c19-01492f290292', 5000.00, '2025-03-01 00:00:00+00', '2025-04-26 11:48:58.935383+00'),
	('13cbdb66-f000-40c8-82fd-5bab02481321', '4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'Tandrify''s Account', 'f2774f6b-3841-420b-ae9a-40ae88c154dc', 1000.00, '2025-03-01 00:00:00+00', '2025-04-26 11:49:10.135977+00'),
	('db9f297e-98cf-45b6-bdab-0fd05d660cb0', 'e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'Main Account', '2a0fe853-284f-443c-9c19-01492f290292', 100.00, '2025-03-01 00:00:00+00', '2025-04-28 15:23:47.061378+00');


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."categories" ("id", "household_id", "created_by_user_id", "name", "type", "created_at", "icon") VALUES
	('f8c300bf-cc3f-401d-abf9-b251a31c4b0c', 'e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'Salary', 'income', '2025-04-28 15:20:58.080035+00', 'payments'),
	('5007efbc-a07a-40ca-bb88-c9898d0a465b', 'e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'Freelance', 'income', '2025-04-28 15:20:58.080035+00', 'work'),
	('66a1d6bf-debb-458c-97be-4c4b70bacff9', 'e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'Gifts', 'income', '2025-04-28 15:20:58.080035+00', 'redeem'),
	('8abecbb9-13b7-453e-ab80-6ad6652463ed', 'e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'Groceries', 'expense', '2025-04-28 15:20:58.080035+00', 'shopping_cart'),
	('483fbc34-3983-413a-a0d5-01f9f69099d7', 'e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'Dining', 'expense', '2025-04-28 15:20:58.080035+00', 'restaurant'),
	('fd76de03-d42a-4082-9ad7-c1338edece9f', 'e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'Transportation', 'expense', '2025-04-28 15:20:58.080035+00', 'directions_car'),
	('0ae6aa16-0f10-4827-80fb-e7cca209c3d0', 'e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'Housing', 'expense', '2025-04-28 15:20:58.080035+00', 'home'),
	('cdb97a3e-e7df-4f18-9d2e-6e6ef1edecac', 'e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'Entertainment', 'expense', '2025-04-28 15:20:58.080035+00', 'videogame_asset'),
	('3f6a1516-2768-4e5d-8223-0c369261897f', 'e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'Utilities', 'expense', '2025-04-28 15:20:58.080035+00', 'bolt'),
	('22ce6fa2-cb65-40b5-bcc7-59d422821dd0', 'e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'Dividend', 'income', '2025-04-28 15:20:58.080035+00', 'trending_up'),
	('55c596da-eac6-4e1a-847e-55e6248ad961', '4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'Salary', 'income', '2025-04-28 15:33:56.786752+00', 'payments'),
	('78ba0afc-15b0-4ce1-a380-cd32d4e8b2e5', '4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'Freelance', 'income', '2025-04-28 15:33:56.786752+00', 'work'),
	('38ea1a4d-1a35-4ee3-9f6d-25bb4067b8a9', '4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'Dividends', 'income', '2025-04-28 15:33:56.786752+00', 'trending_up'),
	('975b1d13-fd80-46ec-8624-5e8bd1d6a885', '4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'Gifts', 'income', '2025-04-28 15:33:56.786752+00', 'redeem'),
	('462c22b8-f893-447a-95ca-ddfc56d03960', '4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'Groceries', 'expense', '2025-04-28 15:33:56.786752+00', 'shopping_cart'),
	('903e40d3-cf26-4c92-9c57-a70127e0548f', '4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'Dining', 'expense', '2025-04-28 15:33:56.786752+00', 'restaurant'),
	('69a6ace3-a759-450f-aab9-26dda1f50cda', '4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'Transportation', 'expense', '2025-04-28 15:33:56.786752+00', 'directions_car'),
	('660d2fb4-3b12-4275-9775-655539f0cecf', '4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'Housing', 'expense', '2025-04-28 15:33:56.786752+00', 'home'),
	('89084ad7-215c-4ea8-bc14-c576f2753ec9', '4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'Entertainment', 'expense', '2025-04-28 15:33:56.786752+00', 'videogame_asset'),
	('d2c6c336-6f78-4208-9168-7a8a0665f9ca', '4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'Utilities', 'expense', '2025-04-28 15:33:56.786752+00', 'bolt');


--
-- Data for Name: household_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."household_members" ("household_id", "user_id", "role", "joined_at") VALUES
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'owner', '2025-04-26 11:26:40.615325+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', 'a0d37bfe-015d-479c-9b2e-7f90893c3e19', 'member', '2025-04-26 11:27:19.207884+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'owner', '2025-04-28 15:20:58.080035+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '27a9b73e-dd53-4f7a-81d0-a4b64e6ca080', 'member', '2025-04-28 15:22:09.302576+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', 'e7a235e2-a8f7-41e4-864d-35883693c029', 'member', '2025-04-28 15:22:44.130143+00');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."users" ("id", "email", "first_name", "last_name", "avatar_url", "created_at", "updated_at") VALUES
	('7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'ryoichifandry@gmail.com', 'Fandresena', 'RANDRIA', NULL, '2025-04-26 11:26:39.873034+00', '2025-04-26 11:26:39.873034+00'),
	('a0d37bfe-015d-479c-9b2e-7f90893c3e19', 'velotsihoarana@gmail.com', 'Tandrify', 'VELO', NULL, '2025-04-26 11:27:18.442742+00', '2025-04-26 11:27:18.442742+00'),
	('557da302-4fe3-4f77-a6f8-89b4a876af70', 'test.user@gmail.com', 'Test', 'USER', NULL, '2025-04-28 15:20:58.080035+00', '2025-04-28 15:20:58.080035+00'),
	('27a9b73e-dd53-4f7a-81d0-a4b64e6ca080', 'valisoa.randria@gmail.com', 'Valisoa', 'RANDRIA', NULL, '2025-04-28 15:22:09.302576+00', '2025-04-28 15:22:09.302576+00'),
	('e7a235e2-a8f7-41e4-864d-35883693c029', 'test2.user@gmail.com', 'Test2', 'USER', NULL, '2025-04-28 15:22:44.130143+00', '2025-04-28 15:22:44.130143+00');


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."transactions" ("household_id", "created_by_user_id", "account_id", "category_id", "amount", "description", "transaction_date", "status", "created_at") VALUES
	-- March 2025 transactions for Fandresena's Household
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '4133bd1a-ff26-404a-8157-f9ad30d1b759', '55c596da-eac6-4e1a-847e-55e6248ad961', 3500.00, 'Monthly salary', '2025-03-01 09:00:00+00', 'completed', '2025-03-01 09:00:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '4133bd1a-ff26-404a-8157-f9ad30d1b759', '462c22b8-f893-447a-95ca-ddfc56d03960', -230.00, 'Grocery shopping', '2025-03-05 10:30:00+00', 'completed', '2025-03-05 10:30:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '4133bd1a-ff26-404a-8157-f9ad30d1b759', '903e40d3-cf26-4c92-9c57-a70127e0548f', -75.00, 'Dinner out', '2025-03-10 19:15:00+00', 'completed', '2025-03-10 19:15:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '4133bd1a-ff26-404a-8157-f9ad30d1b759', '660d2fb4-3b12-4275-9775-655539f0cecf', -1200.00, 'Monthly rent', '2025-03-03 08:00:00+00', 'completed', '2025-03-03 08:00:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '4133bd1a-ff26-404a-8157-f9ad30d1b759', 'd2c6c336-6f78-4208-9168-7a8a0665f9ca', -140.00, 'Electricity bill', '2025-03-15 09:30:00+00', 'completed', '2025-03-15 09:30:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', 'a0d37bfe-015d-479c-9b2e-7f90893c3e19', '13cbdb66-f000-40c8-82fd-5bab02481321', '78ba0afc-15b0-4ce1-a380-cd32d4e8b2e5', 350.00, 'Freelance payment', '2025-03-20 15:20:00+00', 'completed', '2025-03-20 15:20:00+00'),
	
	-- March 2025 transactions for Test's Household
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'db9f297e-98cf-45b6-bdab-0fd05d660cb0', 'f8c300bf-cc3f-401d-abf9-b251a31c4b0c', 2000.00, 'Monthly salary', '2025-03-01 10:00:00+00', 'completed', '2025-03-01 10:00:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'db9f297e-98cf-45b6-bdab-0fd05d660cb0', '8abecbb9-13b7-453e-ab80-6ad6652463ed', -140.00, 'Grocery shopping', '2025-03-08 11:30:00+00', 'completed', '2025-03-08 11:30:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'db9f297e-98cf-45b6-bdab-0fd05d660cb0', '0ae6aa16-0f10-4827-80fb-e7cca209c3d0', -800.00, 'Rent payment', '2025-03-05 09:30:00+00', 'completed', '2025-03-05 09:30:00+00'),
	
	-- April 2025 transactions for Fandresena's Household
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '4133bd1a-ff26-404a-8157-f9ad30d1b759', '55c596da-eac6-4e1a-847e-55e6248ad961', 3500.00, 'Monthly salary', '2025-04-01 09:00:00+00', 'completed', '2025-04-01 09:00:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '4133bd1a-ff26-404a-8157-f9ad30d1b759', '462c22b8-f893-447a-95ca-ddfc56d03960', -240.00, 'Grocery shopping', '2025-04-06 10:30:00+00', 'completed', '2025-04-06 10:30:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '4133bd1a-ff26-404a-8157-f9ad30d1b759', '903e40d3-cf26-4c92-9c57-a70127e0548f', -90.00, 'Restaurant dinner', '2025-04-12 19:30:00+00', 'completed', '2025-04-12 19:30:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '4133bd1a-ff26-404a-8157-f9ad30d1b759', '660d2fb4-3b12-4275-9775-655539f0cecf', -1200.00, 'Monthly rent', '2025-04-03 08:00:00+00', 'completed', '2025-04-03 08:00:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '4133bd1a-ff26-404a-8157-f9ad30d1b759', 'd2c6c336-6f78-4208-9168-7a8a0665f9ca', -145.00, 'Electricity bill', '2025-04-15 09:30:00+00', 'completed', '2025-04-15 09:30:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', 'a0d37bfe-015d-479c-9b2e-7f90893c3e19', '13cbdb66-f000-40c8-82fd-5bab02481321', '78ba0afc-15b0-4ce1-a380-cd32d4e8b2e5', 380.00, 'Freelance payment', '2025-04-18 15:20:00+00', 'completed', '2025-04-18 15:20:00+00'),
	
	-- April 2025 transactions for Test's Household
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'db9f297e-98cf-45b6-bdab-0fd05d660cb0', 'f8c300bf-cc3f-401d-abf9-b251a31c4b0c', 2000.00, 'Monthly salary', '2025-04-01 10:00:00+00', 'completed', '2025-04-01 10:00:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'db9f297e-98cf-45b6-bdab-0fd05d660cb0', '8abecbb9-13b7-453e-ab80-6ad6652463ed', -145.00, 'Grocery shopping', '2025-04-09 11:30:00+00', 'completed', '2025-04-09 11:30:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'db9f297e-98cf-45b6-bdab-0fd05d660cb0', '0ae6aa16-0f10-4827-80fb-e7cca209c3d0', -800.00, 'Rent payment', '2025-04-05 09:30:00+00', 'completed', '2025-04-05 09:30:00+00'),
	
	-- May 2025 transactions
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '4133bd1a-ff26-404a-8157-f9ad30d1b759', '55c596da-eac6-4e1a-847e-55e6248ad961', 3500.00, 'Monthly salary', '2025-05-01 09:00:00+00', 'completed', '2025-05-01 09:00:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '4133bd1a-ff26-404a-8157-f9ad30d1b759', '462c22b8-f893-447a-95ca-ddfc56d03960', -250.00, 'Weekly grocery shopping', '2025-05-03 10:30:00+00', 'completed', '2025-05-03 10:30:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '4133bd1a-ff26-404a-8157-f9ad30d1b759', '903e40d3-cf26-4c92-9c57-a70127e0548f', -85.00, 'Dinner at Italian restaurant', '2025-05-04 19:45:00+00', 'completed', '2025-05-04 19:45:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '4133bd1a-ff26-404a-8157-f9ad30d1b759', '69a6ace3-a759-450f-aab9-26dda1f50cda', -120.00, 'Gas refill', '2025-05-05 12:15:00+00', 'completed', '2025-05-05 12:15:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '4133bd1a-ff26-404a-8157-f9ad30d1b759', '660d2fb4-3b12-4275-9775-655539f0cecf', -1200.00, 'Monthly rent', '2025-05-02 08:00:00+00', 'completed', '2025-05-02 08:00:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '4133bd1a-ff26-404a-8157-f9ad30d1b759', 'd2c6c336-6f78-4208-9168-7a8a0665f9ca', -150.00, 'Electricity bill', '2025-05-05 09:30:00+00', 'completed', '2025-05-05 09:30:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '4133bd1a-ff26-404a-8157-f9ad30d1b759', '89084ad7-215c-4ea8-bc14-c576f2753ec9', -45.00, 'Movie tickets', '2025-05-06 20:00:00+00', 'completed', '2025-05-06 20:00:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', 'a0d37bfe-015d-479c-9b2e-7f90893c3e19', '13cbdb66-f000-40c8-82fd-5bab02481321', '78ba0afc-15b0-4ce1-a380-cd32d4e8b2e5', 400.00, 'Freelance project payment', '2025-05-04 15:20:00+00', 'completed', '2025-05-04 15:20:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', 'a0d37bfe-015d-479c-9b2e-7f90893c3e19', '13cbdb66-f000-40c8-82fd-5bab02481321', '462c22b8-f893-447a-95ca-ddfc56d03960', -80.00, 'Grocery shopping', '2025-05-05 16:45:00+00', 'completed', '2025-05-05 16:45:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', 'a0d37bfe-015d-479c-9b2e-7f90893c3e19', '13cbdb66-f000-40c8-82fd-5bab02481321', '903e40d3-cf26-4c92-9c57-a70127e0548f', -35.00, 'Coffee shop', '2025-05-06 09:00:00+00', 'completed', '2025-05-06 09:00:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'db9f297e-98cf-45b6-bdab-0fd05d660cb0', 'f8c300bf-cc3f-401d-abf9-b251a31c4b0c', 2000.00, 'Monthly salary', '2025-05-01 10:00:00+00', 'completed', '2025-05-01 10:00:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'db9f297e-98cf-45b6-bdab-0fd05d660cb0', '8abecbb9-13b7-453e-ab80-6ad6652463ed', -150.00, 'Grocery shopping', '2025-05-02 11:30:00+00', 'completed', '2025-05-02 11:30:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'db9f297e-98cf-45b6-bdab-0fd05d660cb0', '483fbc34-3983-413a-a0d5-01f9f69099d7', -60.00, 'Restaurant dinner', '2025-05-03 19:00:00+00', 'completed', '2025-05-03 19:00:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'db9f297e-98cf-45b6-bdab-0fd05d660cb0', '0ae6aa16-0f10-4827-80fb-e7cca209c3d0', -800.00, 'Rent payment', '2025-05-04 09:30:00+00', 'completed', '2025-05-04 09:30:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', 'e7a235e2-a8f7-41e4-864d-35883693c029', 'db9f297e-98cf-45b6-bdab-0fd05d660cb0', '3f6a1516-2768-4e5d-8223-0c369261897f', -100.00, 'Internet bill', '2025-05-05 10:15:00+00', 'completed', '2025-05-05 10:15:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', 'e7a235e2-a8f7-41e4-864d-35883693c029', 'db9f297e-98cf-45b6-bdab-0fd05d660cb0', 'cdb97a3e-e7df-4f18-9d2e-6e6ef1edecac', -30.00, 'Streaming service subscription', '2025-05-06 14:20:00+00', 'completed', '2025-05-06 14:20:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', 'e7a235e2-a8f7-41e4-864d-35883693c029', 'db9f297e-98cf-45b6-bdab-0fd05d660cb0', '5007efbc-a07a-40ca-bb88-c9898d0a465b', 300.00, 'Side project payment', '2025-05-07 16:00:00+00', 'completed', '2025-05-07 16:00:00+00');


--
-- Data for Name: budget_allocations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."budget_allocations" ("household_id", "created_by_user_id", "category_id", "month", "allocated_amount", "created_at", "updated_at") VALUES
	-- March 2025 budget allocations for Fandresena's Household
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '462c22b8-f893-447a-95ca-ddfc56d03960', '2025-03-01', 300.00, '2025-03-01 08:00:00+00', '2025-03-01 08:00:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '903e40d3-cf26-4c92-9c57-a70127e0548f', '2025-03-01', 100.00, '2025-03-01 08:00:00+00', '2025-03-01 08:00:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '69a6ace3-a759-450f-aab9-26dda1f50cda', '2025-03-01', 150.00, '2025-03-01 08:00:00+00', '2025-03-01 08:00:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '660d2fb4-3b12-4275-9775-655539f0cecf', '2025-03-01', 1200.00, '2025-03-01 08:00:00+00', '2025-03-01 08:00:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'd2c6c336-6f78-4208-9168-7a8a0665f9ca', '2025-03-01', 180.00, '2025-03-01 08:00:00+00', '2025-03-01 08:00:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '89084ad7-215c-4ea8-bc14-c576f2753ec9', '2025-03-01', 80.00, '2025-03-01 08:00:00+00', '2025-03-01 08:00:00+00'),
	
	-- March 2025 budget allocations for Test's Household
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', '8abecbb9-13b7-453e-ab80-6ad6652463ed', '2025-03-01', 200.00, '2025-03-01 08:30:00+00', '2025-03-01 08:30:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', '483fbc34-3983-413a-a0d5-01f9f69099d7', '2025-03-01', 120.00, '2025-03-01 08:30:00+00', '2025-03-01 08:30:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', '0ae6aa16-0f10-4827-80fb-e7cca209c3d0', '2025-03-01', 800.00, '2025-03-01 08:30:00+00', '2025-03-01 08:30:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', '3f6a1516-2768-4e5d-8223-0c369261897f', '2025-03-01', 130.00, '2025-03-01 08:30:00+00', '2025-03-01 08:30:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'cdb97a3e-e7df-4f18-9d2e-6e6ef1edecac', '2025-03-01', 80.00, '2025-03-01 08:30:00+00', '2025-03-01 08:30:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '462c22b8-f893-447a-95ca-ddfc56d03960', '2025-05-01', 400.00, '2025-05-01 08:00:00+00', '2025-05-01 08:00:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '903e40d3-cf26-4c92-9c57-a70127e0548f', '2025-05-01', 150.00, '2025-05-01 08:00:00+00', '2025-05-01 08:00:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '69a6ace3-a759-450f-aab9-26dda1f50cda', '2025-05-01', 200.00, '2025-05-01 08:00:00+00', '2025-05-01 08:00:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '660d2fb4-3b12-4275-9775-655539f0cecf', '2025-05-01', 1200.00, '2025-05-01 08:00:00+00', '2025-05-01 08:00:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', 'd2c6c336-6f78-4208-9168-7a8a0665f9ca', '2025-05-01', 200.00, '2025-05-01 08:00:00+00', '2025-05-01 08:00:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '89084ad7-215c-4ea8-bc14-c576f2753ec9', '2025-05-01', 100.00, '2025-05-01 08:00:00+00', '2025-05-01 08:00:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', '8abecbb9-13b7-453e-ab80-6ad6652463ed', '2025-05-01', 300.00, '2025-05-01 08:30:00+00', '2025-05-01 08:30:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', '483fbc34-3983-413a-a0d5-01f9f69099d7', '2025-05-01', 150.00, '2025-05-01 08:30:00+00', '2025-05-01 08:30:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', '0ae6aa16-0f10-4827-80fb-e7cca209c3d0', '2025-05-01', 800.00, '2025-05-01 08:30:00+00', '2025-05-01 08:30:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', '3f6a1516-2768-4e5d-8223-0c369261897f', '2025-05-01', 150.00, '2025-05-01 08:30:00+00', '2025-05-01 08:30:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', 'cdb97a3e-e7df-4f18-9d2e-6e6ef1edecac', '2025-05-01', 100.00, '2025-05-01 08:30:00+00', '2025-05-01 08:30:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '462c22b8-f893-447a-95ca-ddfc56d03960', '2025-04-01', 350.00, '2025-04-01 08:00:00+00', '2025-04-01 08:00:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '903e40d3-cf26-4c92-9c57-a70127e0548f', '2025-04-01', 120.00, '2025-04-01 08:00:00+00', '2025-04-01 08:00:00+00'),
	('4b3cb6ce-b3d6-4934-981b-ba0e7a97f67c', '7f391dd8-0c4b-4c4d-bbe9-941959e59a34', '660d2fb4-3b12-4275-9775-655539f0cecf', '2025-04-01', 1200.00, '2025-04-01 08:00:00+00', '2025-04-01 08:00:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', '8abecbb9-13b7-453e-ab80-6ad6652463ed', '2025-04-01', 250.00, '2025-04-01 08:30:00+00', '2025-04-01 08:30:00+00'),
	('e8796342-268d-4018-8ac4-b81e3ae4f975', '557da302-4fe3-4f77-a6f8-89b4a876af70', '0ae6aa16-0f10-4827-80fb-e7cca209c3d0', '2025-04-01', 800.00, '2025-04-01 08:30:00+00', '2025-04-01 08:30:00+00');


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 26, true);


--
-- Name: hooks_id_seq; Type: SEQUENCE SET; Schema: supabase_functions; Owner: supabase_functions_admin
--

SELECT pg_catalog.setval('"supabase_functions"."hooks_id_seq"', 1, false);


--
-- PostgreSQL database dump complete
--

RESET ALL;
