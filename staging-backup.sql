--
-- PostgreSQL database dump
--

-- Dumped from database version 14.10
-- Dumped by pg_dump version 15.3

-- Started on 2024-12-02 11:14:32

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
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: rdsadmin
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO rdsadmin;

--
-- TOC entry 241 (class 1255 OID 71601)
-- Name: update_timestamp(); Type: FUNCTION; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE FUNCTION public.update_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_timestamp() OWNER TO a1sa0120vrtappshrd01u;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 209 (class 1259 OID 20527)
-- Name: customer; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.customer (
    customer_id character varying(10) NOT NULL,
    image_id character varying(50),
    name character varying(50),
    role character varying(50),
    description character varying(5000),
    domain character varying(50)
);


ALTER TABLE public.customer OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 221 (class 1259 OID 22614)
-- Name: customer2; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.customer2 (
    customer_id character varying(10) NOT NULL,
    image_id character varying(50),
    name character varying(50),
    role character varying(50),
    description character varying(5000),
    domain character varying(50),
    y_o_p double precision,
    user_role character(50),
    product character(50),
    language character varying(10) DEFAULT 'en'::character varying
);


ALTER TABLE public.customer2 OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 226 (class 1259 OID 24008)
-- Name: evaluated_practice_tb; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.evaluated_practice_tb (
    practice_id character(50) NOT NULL,
    prompt_id character(50) NOT NULL,
    customer_id character(10) NOT NULL,
    user_id character(10),
    skill text,
    sub_skill text,
    eval_chat text,
    is_assignment text,
    timed_assignment text,
    assignment_name text,
    evaluated_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    duration interval,
    questions text,
    scores text,
    comments text,
    improvements text
);


ALTER TABLE public.evaluated_practice_tb OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 229 (class 1259 OID 24055)
-- Name: evaluatedassignments; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.evaluatedassignments (
    conversation_id character varying(50) NOT NULL,
    user_id character varying(50),
    prompt_id character varying(50),
    conversation jsonb,
    is_assignment boolean,
    assignment_name character varying(50),
    difficulty text,
    tone_score double precision,
    on_label_recommendations_score double precision,
    appropriate_team_reference_handoff_score double precision,
    meets_conversation_objectives_score double precision,
    tone_comments text,
    on_label_recommendations_comments text,
    appropriate_team_reference_handoff_comments text,
    meets_conversation_objectives_comments text,
    evaluated_on timestamp without time zone,
    duration interval,
    timed boolean
);


ALTER TABLE public.evaluatedassignments OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 211 (class 1259 OID 20600)
-- Name: evaluatedconversations; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.evaluatedconversations (
    conversation_id character varying(50) NOT NULL,
    prompt_id character varying(50),
    conversation jsonb,
    evaluated_on timestamp without time zone,
    introduction_score double precision,
    topic_introduction_score double precision,
    topic_details_score double precision,
    topic_summary_score double precision,
    closing_score double precision,
    classifed_conversation text,
    introduction_comments text,
    topic_introduction_comments text,
    topic_details_comments text,
    topic_summary_comments text,
    closing_comments text,
    user_id character varying(50),
    is_assignment boolean DEFAULT false,
    assignment_name character varying(50),
    duration interval,
    timed boolean DEFAULT false,
    audio_analysis jsonb,
    video_analysis jsonb
);


ALTER TABLE public.evaluatedconversations OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 231 (class 1259 OID 24946)
-- Name: evaluatedconversations_blinded_daybue; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.evaluatedconversations_blinded_daybue (
    conversation_id character varying(50) NOT NULL,
    prompt_id character varying(50),
    conversation jsonb,
    evaluated_on timestamp without time zone,
    difficulty text,
    tone_score double precision,
    on_label_recommendations_score double precision,
    appropriate_team_reference_handoff_score double precision,
    meets_conversation_objectives_score double precision,
    tone_comments text,
    on_label_recommendations_comments text,
    appropriate_team_reference_handoff_comments text,
    meets_conversation_objectives_comments text,
    user_id character varying(50),
    is_assignment boolean DEFAULT false,
    assignment_name character varying(50),
    duration interval,
    timed boolean DEFAULT false,
    audio_analysis jsonb,
    video_analysis jsonb
);


ALTER TABLE public.evaluatedconversations_blinded_daybue OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 237 (class 1259 OID 68592)
-- Name: evaluatedconversations_blinded_daybue_mainstay2; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.evaluatedconversations_blinded_daybue_mainstay2 (
    conversation_id character varying(50) NOT NULL,
    prompt_id character varying(50),
    conversation jsonb,
    evaluated_on timestamp without time zone,
    difficulty text,
    empathy_score double precision,
    credibility_score double precision,
    context_score double precision,
    support_score double precision,
    empathy_comments text,
    credibility_comments text,
    context_comments text,
    support_comments text,
    user_id character varying(50),
    is_assignment boolean DEFAULT false,
    assignment_name character varying(50),
    duration interval,
    timed boolean DEFAULT false,
    audio_analysis jsonb,
    video_analysis jsonb
);


ALTER TABLE public.evaluatedconversations_blinded_daybue_mainstay2 OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 240 (class 1259 OID 72116)
-- Name: evaluatedconversations_coaching; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.evaluatedconversations_coaching (
    conversation_id character varying(50) NOT NULL,
    prompt_id character varying(50),
    conversation jsonb,
    evaluated_on timestamp without time zone,
    difficulty text,
    coaching_score double precision,
    coaching_comments text,
    user_id character varying(50),
    is_assignment boolean DEFAULT false,
    assignment_name character varying(50),
    duration interval,
    timed boolean DEFAULT false,
    audio_analysis jsonb,
    video_analysis jsonb
);


ALTER TABLE public.evaluatedconversations_coaching OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 232 (class 1259 OID 25345)
-- Name: evaluatedconversations_dermatologist; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.evaluatedconversations_dermatologist (
    conversation_id character varying(50) NOT NULL,
    prompt_id character varying(50),
    conversation jsonb,
    evaluated_on timestamp without time zone,
    difficulty text,
    integration_and_implementation_score double precision,
    communication_and_engagement_score double precision,
    professionalism_and_engagement_score double precision,
    alignment_with_objectives_score double precision,
    feedback_and_next_steps_score double precision,
    integration_and_implementation_comments text,
    communication_and_engagement_comments text,
    professionalism_and_engagement_comments text,
    alignment_with_objectives_comments text,
    feedback_and_next_steps_comments text,
    user_id character varying(50),
    is_assignment boolean DEFAULT false,
    assignment_name character varying(50),
    duration interval,
    timed boolean DEFAULT false,
    audio_analysis jsonb,
    video_analysis jsonb
);


ALTER TABLE public.evaluatedconversations_dermatologist OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 233 (class 1259 OID 25358)
-- Name: evaluatedconversations_endocrinologist_english; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.evaluatedconversations_endocrinologist_english (
    conversation_id character varying(50) NOT NULL,
    prompt_id character varying(50),
    conversation jsonb,
    evaluated_on timestamp without time zone,
    difficulty text,
    tone_score double precision,
    on_label_recommendations_score double precision,
    appropriate_team_reference_handoff_score double precision,
    meets_conversation_objectives_score double precision,
    tone_comments text,
    on_label_recommendations_comments text,
    appropriate_team_reference_handoff_comments text,
    meets_conversation_objectives_comments text,
    user_id character varying(50),
    is_assignment boolean DEFAULT false,
    assignment_name character varying(50),
    duration interval,
    timed boolean DEFAULT false,
    audio_analysis jsonb,
    video_analysis jsonb
);


ALTER TABLE public.evaluatedconversations_endocrinologist_english OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 234 (class 1259 OID 25371)
-- Name: evaluatedconversations_endocrinologist_japanese; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.evaluatedconversations_endocrinologist_japanese (
    conversation_id character varying(50) NOT NULL,
    prompt_id character varying(50),
    conversation jsonb,
    evaluated_on timestamp without time zone,
    difficulty text,
    tone_score double precision,
    on_label_recommendations_score double precision,
    appropriate_team_reference_handoff_score double precision,
    meets_conversation_objectives_score double precision,
    tone_comments text,
    on_label_recommendations_comments text,
    appropriate_team_reference_handoff_comments text,
    meets_conversation_objectives_comments text,
    user_id character varying(50),
    is_assignment boolean DEFAULT false,
    assignment_name character varying(50),
    duration interval,
    timed boolean DEFAULT false,
    audio_analysis jsonb,
    video_analysis jsonb
);


ALTER TABLE public.evaluatedconversations_endocrinologist_japanese OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 217 (class 1259 OID 21638)
-- Name: evaluatedconversations_endocrinologist_np; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.evaluatedconversations_endocrinologist_np (
    conversation_id character varying(50) NOT NULL,
    prompt_id character varying(50),
    conversation jsonb,
    evaluated_on timestamp without time zone,
    difficulty text,
    communication_effectiveness_score double precision,
    educational_support_score double precision,
    safety_management_score double precision,
    collaboration_score double precision,
    communication_effectiveness_comments text,
    educational_support_comments text,
    safety_management_comments text,
    collaboration_comments text,
    user_id character varying(50),
    is_assignment boolean DEFAULT false,
    assignment_name character varying(50),
    duration interval,
    timed boolean DEFAULT false,
    audio_analysis jsonb,
    video_analysis jsonb
);


ALTER TABLE public.evaluatedconversations_endocrinologist_np OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 239 (class 1259 OID 72102)
-- Name: evaluatedconversations_hospitality; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.evaluatedconversations_hospitality (
    conversation_id character varying(50) NOT NULL,
    prompt_id character varying(50),
    conversation jsonb,
    evaluated_on timestamp without time zone,
    difficulty text,
    tone_score double precision,
    client_interaction_score double precision,
    offered_solutions_score double precision,
    tone_comments text,
    client_interaction_comments text,
    offered_solutions_comments text,
    user_id character varying(50),
    is_assignment boolean DEFAULT false,
    assignment_name character varying(50),
    duration interval,
    timed boolean DEFAULT false,
    audio_analysis jsonb,
    video_analysis jsonb
);


ALTER TABLE public.evaluatedconversations_hospitality OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 216 (class 1259 OID 20961)
-- Name: evaluatedconversations_itdecisionmaker; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.evaluatedconversations_itdecisionmaker (
    conversation_id character varying(50) NOT NULL,
    prompt_id character varying(50),
    conversation jsonb,
    evaluated_on timestamp without time zone,
    difficulty text,
    tone_score double precision,
    on_label_recommendations_score double precision,
    appropriate_team_reference_handoff_score double precision,
    meets_conversation_objectives_score double precision,
    tone_comments text,
    on_label_recommendations_comments text,
    appropriate_team_reference_handoff_comments text,
    meets_conversation_objectives_comments text,
    user_id character varying(50),
    is_assignment boolean DEFAULT false,
    assignment_name character varying(50),
    duration interval,
    timed boolean DEFAULT false,
    audio_analysis jsonb,
    video_analysis jsonb
);


ALTER TABLE public.evaluatedconversations_itdecisionmaker OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 212 (class 1259 OID 20657)
-- Name: evaluatedconversations_jp; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.evaluatedconversations_jp (
    conversation_id character varying(50) NOT NULL,
    prompt_id character varying(50),
    conversation jsonb,
    evaluated_on timestamp without time zone,
    introduction_score double precision,
    topic_introduction_score double precision,
    topic_details_score double precision,
    topic_summary_score double precision,
    closing_score double precision,
    classifed_conversation text,
    introduction_comments text,
    topic_introduction_comments text,
    topic_details_comments text,
    topic_summary_comments text,
    closing_comments text,
    user_id character varying(50),
    is_assignment boolean DEFAULT false,
    assignment_name character varying(50),
    duration interval,
    timed boolean DEFAULT false,
    audio_analysis jsonb,
    video_analysis jsonb
);


ALTER TABLE public.evaluatedconversations_jp OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 218 (class 1259 OID 21690)
-- Name: evaluatedconversations_oncologist; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.evaluatedconversations_oncologist (
    conversation_id character varying(50) NOT NULL,
    prompt_id character varying(50),
    conversation jsonb,
    evaluated_on timestamp without time zone,
    difficulty text,
    tone_score double precision,
    on_label_recommendations_score double precision,
    appropriate_team_reference_handoff_score double precision,
    meets_conversation_objectives_score double precision,
    tone_comments text,
    on_label_recommendations_comments text,
    appropriate_team_reference_handoff_comments text,
    meets_conversation_objectives_comments text,
    user_id character varying(50),
    is_assignment boolean DEFAULT false,
    assignment_name character varying(50),
    duration interval,
    timed boolean DEFAULT false,
    audio_analysis jsonb,
    video_analysis jsonb
);


ALTER TABLE public.evaluatedconversations_oncologist OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 214 (class 1259 OID 20757)
-- Name: evaluatedconversations_ophthalmologist_msl; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.evaluatedconversations_ophthalmologist_msl (
    conversation_id character varying(50) NOT NULL,
    prompt_id character varying(50),
    conversation jsonb,
    evaluated_on timestamp without time zone,
    difficulty text,
    tone_score double precision,
    on_label_recommendations_score double precision,
    appropriate_team_reference_handoff_score double precision,
    meets_conversation_objectives_score double precision,
    tone_comments text,
    on_label_recommendations_comments text,
    appropriate_team_reference_handoff_comments text,
    meets_conversation_objectives_comments text,
    user_id character varying(50),
    is_assignment boolean DEFAULT false,
    assignment_name character varying(50),
    duration interval,
    timed boolean DEFAULT false,
    audio_analysis jsonb,
    video_analysis jsonb
);


ALTER TABLE public.evaluatedconversations_ophthalmologist_msl OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 213 (class 1259 OID 20743)
-- Name: evaluatedconversations_ophthalmologist_sales_rep; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.evaluatedconversations_ophthalmologist_sales_rep (
    conversation_id character varying(50) NOT NULL,
    prompt_id character varying(50),
    conversation jsonb,
    evaluated_on timestamp without time zone,
    difficulty text,
    tone_score double precision,
    on_label_recommendations_score double precision,
    appropriate_team_reference_handoff_score double precision,
    meets_conversation_objectives_score double precision,
    tone_comments text,
    on_label_recommendations_comments text,
    appropriate_team_reference_handoff_comments text,
    meets_conversation_objectives_comments text,
    user_id character varying(50),
    is_assignment boolean DEFAULT false,
    assignment_name character varying(50),
    duration interval,
    timed boolean DEFAULT false,
    audio_analysis jsonb,
    video_analysis jsonb
);


ALTER TABLE public.evaluatedconversations_ophthalmologist_sales_rep OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 219 (class 1259 OID 21703)
-- Name: evaluatedconversations_retail; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.evaluatedconversations_retail (
    conversation_id character varying(50) NOT NULL,
    prompt_id character varying(50),
    conversation jsonb,
    evaluated_on timestamp without time zone,
    difficulty text,
    tone_score double precision,
    on_label_recommendations_score double precision,
    appropriate_team_reference_handoff_score double precision,
    meets_conversation_objectives_score double precision,
    tone_comments text,
    on_label_recommendations_comments text,
    appropriate_team_reference_handoff_comments text,
    meets_conversation_objectives_comments text,
    user_id character varying(50),
    is_assignment boolean DEFAULT false,
    assignment_name character varying(50),
    duration interval,
    timed boolean DEFAULT false,
    audio_analysis jsonb,
    video_analysis jsonb
);


ALTER TABLE public.evaluatedconversations_retail OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 225 (class 1259 OID 24001)
-- Name: ongoing_practice_tb; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.ongoing_practice_tb (
    practice_id character(50) NOT NULL,
    prompt_id character(50),
    skill text,
    sub_skill text,
    customer_id character(10),
    user_id character(10),
    chat text,
    is_assignment text,
    timed_assignment text,
    assignment_name text,
    call_start timestamp without time zone,
    call_end timestamp without time zone,
    call_diff interval,
    last_modified timestamp without time zone,
    questions text
);


ALTER TABLE public.ongoing_practice_tb OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 220 (class 1259 OID 22556)
-- Name: ongoingassignments; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.ongoingassignments (
    conversation_id character varying(50) NOT NULL,
    user_id character varying(50),
    prompt_id character varying(50),
    conversation jsonb,
    is_assignment boolean,
    assignment_name character varying(50),
    call_start timestamp without time zone,
    call_end timestamp without time zone,
    call_diff interval,
    last_modified timestamp without time zone,
    difficulty text,
    timed boolean
);


ALTER TABLE public.ongoingassignments OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 230 (class 1259 OID 24073)
-- Name: ongoingconversations; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.ongoingconversations (
    conversation_id character varying(50) NOT NULL,
    prompt_id character varying(50),
    conversation jsonb,
    last_modified timestamp without time zone,
    difficulty character varying(50) NOT NULL
);


ALTER TABLE public.ongoingconversations OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 215 (class 1259 OID 20870)
-- Name: ongoingconversations_jp; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.ongoingconversations_jp (
    conversation_id character varying(50) NOT NULL,
    prompt_id character varying(50),
    conversation jsonb,
    last_modified timestamp without time zone,
    difficulty character varying(50) NOT NULL
);


ALTER TABLE public.ongoingconversations_jp OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 224 (class 1259 OID 23995)
-- Name: practice_customer_tb2; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.practice_customer_tb2 (
    customer_id character(10) NOT NULL,
    name character(50),
    summary text,
    skill text,
    sub_skill text,
    questions text
);


ALTER TABLE public.practice_customer_tb2 OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 227 (class 1259 OID 24015)
-- Name: practice_prompts_tb; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.practice_prompts_tb (
    prompt_id character(50) NOT NULL,
    customer_id character(10) NOT NULL,
    summary text,
    skill text,
    conversation_pt text,
    evaluation_pt text
);


ALTER TABLE public.practice_prompts_tb OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 210 (class 1259 OID 20574)
-- Name: prompts; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.prompts (
    prompt_id character varying(60) NOT NULL,
    topic character varying(50),
    domain character varying(50),
    prompt character varying(50000),
    difficulty character varying(10),
    customer_id character varying(10),
    objective text,
    short_conversation_prompt text,
    guard_rail text,
    customer_segment character varying(50),
    customer_concern character varying(50),
    interaction_type character varying(50),
    last_interaction character varying(50)
);


ALTER TABLE public.prompts OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 223 (class 1259 OID 23354)
-- Name: prompts2; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.prompts2 (
    prompt_id character varying(60) NOT NULL,
    topic character varying(50),
    domain character varying(50),
    prompt character varying(50000),
    difficulty character varying(10),
    customer_id character varying(10),
    objective text,
    short_conversation_prompt text,
    guard_rail text,
    customer_segment character varying(50),
    customer_concern character varying(50),
    interaction_type character varying(50),
    last_interaction character varying(50)
);


ALTER TABLE public.prompts2 OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 235 (class 1259 OID 27886)
-- Name: table_test; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.table_test (
    conversation_id character varying(50),
    prompt_id character varying(50),
    conversation jsonb,
    evaluated_on timestamp without time zone,
    difficulty text,
    tone_score double precision,
    on_label_recommendations_score double precision,
    appropriate_team_reference_handoff_score double precision,
    meets_conversation_objectives_score double precision,
    tone_comments text,
    on_label_recommendations_comments text,
    appropriate_team_reference_handoff_comments text,
    meets_conversation_objectives_comments text,
    user_id character varying(50),
    is_assignment boolean,
    assignment_name character varying(50),
    duration interval,
    timed boolean
);


ALTER TABLE public.table_test OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 238 (class 1259 OID 71590)
-- Name: taskstatus_blinded_daybue; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.taskstatus_blinded_daybue (
    task_id character varying(255) NOT NULL,
    status character varying(50) NOT NULL,
    conversation_id character varying(255),
    type character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT taskstatus_blinded_daybue_status_check CHECK (((status)::text = ANY ((ARRAY['started'::character varying, 'in_progress'::character varying, 'completed'::character varying])::text[]))),
    CONSTRAINT taskstatus_blinded_daybue_type_check CHECK (((type)::text = ANY ((ARRAY['audio'::character varying, 'video'::character varying])::text[])))
);


ALTER TABLE public.taskstatus_blinded_daybue OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 236 (class 1259 OID 45233)
-- Name: temp_prompts; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.temp_prompts (
    prompt_id character varying(60),
    topic character varying(50),
    domain character varying(50),
    prompt character varying(50000),
    difficulty character varying(10),
    customer_id character varying(10),
    objective text,
    short_conversation_prompt text,
    guard_rail text,
    customer_segment character varying(50),
    customer_concern character varying(50),
    interaction_type character varying(50),
    last_interaction character varying(50)
);


ALTER TABLE public.temp_prompts OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 228 (class 1259 OID 24049)
-- Name: users_tb; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.users_tb (
    user_id character varying(50) NOT NULL,
    team_id character varying(50),
    team_name character varying(10),
    h_role character varying(50),
    image_id character varying(10),
    user_name text,
    designation text,
    email_id text
);


ALTER TABLE public.users_tb OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 222 (class 1259 OID 22669)
-- Name: vishal_dummy; Type: TABLE; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TABLE public.vishal_dummy (
    conversation_id character varying(50) NOT NULL,
    prompt_id character varying(50) NOT NULL
);


ALTER TABLE public.vishal_dummy OWNER TO a1sa0120vrtappshrd01u;

--
-- TOC entry 4326 (class 2606 OID 16439)
-- Name: customer2 customer2_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.customer2
    ADD CONSTRAINT customer2_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 4288 (class 2606 OID 16440)
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 4337 (class 2606 OID 16441)
-- Name: evaluated_practice_tb evaluated_practice_tb_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluated_practice_tb
    ADD CONSTRAINT evaluated_practice_tb_pkey PRIMARY KEY (practice_id);


--
-- TOC entry 4345 (class 2606 OID 16442)
-- Name: evaluatedassignments evaluatedassignments_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedassignments
    ADD CONSTRAINT evaluatedassignments_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4368 (class 2606 OID 68600)
-- Name: evaluatedconversations_blinded_daybue_mainstay2 evaluatedconversations_blinded_daybue_mainstay2_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_blinded_daybue_mainstay2
    ADD CONSTRAINT evaluatedconversations_blinded_daybue_mainstay2_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4352 (class 2606 OID 16443)
-- Name: evaluatedconversations_blinded_daybue evaluatedconversations_blinded_daybue_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_blinded_daybue
    ADD CONSTRAINT evaluatedconversations_blinded_daybue_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4377 (class 2606 OID 72124)
-- Name: evaluatedconversations_coaching evaluatedconversations_coaching_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_coaching
    ADD CONSTRAINT evaluatedconversations_coaching_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4356 (class 2606 OID 16444)
-- Name: evaluatedconversations_dermatologist evaluatedconversations_dermatologist_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_dermatologist
    ADD CONSTRAINT evaluatedconversations_dermatologist_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4360 (class 2606 OID 16445)
-- Name: evaluatedconversations_endocrinologist_english evaluatedconversations_endocrinologist_english_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_endocrinologist_english
    ADD CONSTRAINT evaluatedconversations_endocrinologist_english_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4364 (class 2606 OID 16446)
-- Name: evaluatedconversations_endocrinologist_japanese evaluatedconversations_endocrinologist_japanese_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_endocrinologist_japanese
    ADD CONSTRAINT evaluatedconversations_endocrinologist_japanese_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4311 (class 2606 OID 16447)
-- Name: evaluatedconversations_endocrinologist_np evaluatedconversations_endocrinologist_np_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_endocrinologist_np
    ADD CONSTRAINT evaluatedconversations_endocrinologist_np_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4373 (class 2606 OID 72110)
-- Name: evaluatedconversations_hospitality evaluatedconversations_hospitality_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_hospitality
    ADD CONSTRAINT evaluatedconversations_hospitality_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4307 (class 2606 OID 16448)
-- Name: evaluatedconversations_itdecisionmaker evaluatedconversations_itdecisionmaker_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_itdecisionmaker
    ADD CONSTRAINT evaluatedconversations_itdecisionmaker_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4294 (class 2606 OID 16449)
-- Name: evaluatedconversations_jp evaluatedconversations_jp_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_jp
    ADD CONSTRAINT evaluatedconversations_jp_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4315 (class 2606 OID 16450)
-- Name: evaluatedconversations_oncologist evaluatedconversations_oncologist_english_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_oncologist
    ADD CONSTRAINT evaluatedconversations_oncologist_english_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4300 (class 2606 OID 16451)
-- Name: evaluatedconversations_ophthalmologist_msl evaluatedconversations_ophthalmologist_msl_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_ophthalmologist_msl
    ADD CONSTRAINT evaluatedconversations_ophthalmologist_msl_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4296 (class 2606 OID 16452)
-- Name: evaluatedconversations_ophthalmologist_sales_rep evaluatedconversations_ophthalmologist_sales_rep_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_ophthalmologist_sales_rep
    ADD CONSTRAINT evaluatedconversations_ophthalmologist_sales_rep_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4292 (class 2606 OID 16453)
-- Name: evaluatedconversations evaluatedconversations_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations
    ADD CONSTRAINT evaluatedconversations_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4319 (class 2606 OID 16454)
-- Name: evaluatedconversations_retail evaluatedconversations_retail_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_retail
    ADD CONSTRAINT evaluatedconversations_retail_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4335 (class 2606 OID 16455)
-- Name: ongoing_practice_tb ongoing_practice_tb_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.ongoing_practice_tb
    ADD CONSTRAINT ongoing_practice_tb_pkey PRIMARY KEY (practice_id);


--
-- TOC entry 4324 (class 2606 OID 16456)
-- Name: ongoingassignments ongoingassignments_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.ongoingassignments
    ADD CONSTRAINT ongoingassignments_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4305 (class 2606 OID 16457)
-- Name: ongoingconversations_jp ongoingconversations_jp_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.ongoingconversations_jp
    ADD CONSTRAINT ongoingconversations_jp_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4350 (class 2606 OID 16458)
-- Name: ongoingconversations ongoingconversations_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.ongoingconversations
    ADD CONSTRAINT ongoingconversations_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4340 (class 2606 OID 16459)
-- Name: practice_prompts_tb practice_prompts_tb_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.practice_prompts_tb
    ADD CONSTRAINT practice_prompts_tb_pkey PRIMARY KEY (prompt_id);


--
-- TOC entry 4332 (class 2606 OID 16460)
-- Name: prompts2 prompts2_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.prompts2
    ADD CONSTRAINT prompts2_pkey PRIMARY KEY (prompt_id);


--
-- TOC entry 4290 (class 2606 OID 16461)
-- Name: prompts prompts_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.prompts
    ADD CONSTRAINT prompts_pkey PRIMARY KEY (prompt_id);


--
-- TOC entry 4371 (class 2606 OID 71600)
-- Name: taskstatus_blinded_daybue taskstatus_blinded_daybue_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.taskstatus_blinded_daybue
    ADD CONSTRAINT taskstatus_blinded_daybue_pkey PRIMARY KEY (task_id);


--
-- TOC entry 4343 (class 2606 OID 16462)
-- Name: users_tb users_tb_pkey; Type: CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.users_tb
    ADD CONSTRAINT users_tb_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4322 (class 1259 OID 89745)
-- Name: idx_conversation_id_assignment; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_conversation_id_assignment ON public.ongoingassignments USING btree (conversation_id);


--
-- TOC entry 4348 (class 1259 OID 89746)
-- Name: idx_conversation_id_conversation; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_conversation_id_conversation ON public.ongoingconversations USING btree (conversation_id);


--
-- TOC entry 4303 (class 1259 OID 89747)
-- Name: idx_conversation_id_conversation_jp; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_conversation_id_conversation_jp ON public.ongoingconversations_jp USING btree (conversation_id);


--
-- TOC entry 4327 (class 1259 OID 90480)
-- Name: idx_domain_lang; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_domain_lang ON public.customer2 USING btree (domain, language);


--
-- TOC entry 4346 (class 1259 OID 90492)
-- Name: idx_ea_en; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_ea_en ON public.evaluatedassignments USING btree (is_assignment);


--
-- TOC entry 4347 (class 1259 OID 90561)
-- Name: idx_eadiff; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_eadiff ON public.evaluatedassignments USING btree (difficulty);


--
-- TOC entry 4353 (class 1259 OID 90562)
-- Name: idx_ebd_diff; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_ebd_diff ON public.evaluatedconversations_blinded_daybue USING btree (difficulty);


--
-- TOC entry 4354 (class 1259 OID 90483)
-- Name: idx_ebd_en; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_ebd_en ON public.evaluatedconversations_blinded_daybue USING btree (is_assignment);


--
-- TOC entry 4369 (class 1259 OID 90484)
-- Name: idx_ebdm_en; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_ebdm_en ON public.evaluatedconversations_blinded_daybue_mainstay2 USING btree (is_assignment);


--
-- TOC entry 4378 (class 1259 OID 90563)
-- Name: idx_ec_diff; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_ec_diff ON public.evaluatedconversations_coaching USING btree (difficulty);


--
-- TOC entry 4379 (class 1259 OID 90493)
-- Name: idx_ec_en; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_ec_en ON public.evaluatedconversations_coaching USING btree (is_assignment);


--
-- TOC entry 4357 (class 1259 OID 90564)
-- Name: idx_ed_diff; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_ed_diff ON public.evaluatedconversations_dermatologist USING btree (difficulty);


--
-- TOC entry 4358 (class 1259 OID 90488)
-- Name: idx_ed_en; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_ed_en ON public.evaluatedconversations_dermatologist USING btree (is_assignment);


--
-- TOC entry 4361 (class 1259 OID 90485)
-- Name: idx_ee_en; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_ee_en ON public.evaluatedconversations_endocrinologist_english USING btree (is_assignment);


--
-- TOC entry 4365 (class 1259 OID 90482)
-- Name: idx_ee_jp; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_ee_jp ON public.evaluatedconversations_endocrinologist_japanese USING btree (is_assignment);


--
-- TOC entry 4362 (class 1259 OID 90565)
-- Name: idx_eee_diff; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_eee_diff ON public.evaluatedconversations_endocrinologist_english USING btree (difficulty);


--
-- TOC entry 4366 (class 1259 OID 90566)
-- Name: idx_eej_diff; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_eej_diff ON public.evaluatedconversations_endocrinologist_japanese USING btree (difficulty);


--
-- TOC entry 4312 (class 1259 OID 90567)
-- Name: idx_een_diff; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_een_diff ON public.evaluatedconversations_endocrinologist_np USING btree (difficulty);


--
-- TOC entry 4313 (class 1259 OID 90490)
-- Name: idx_eenp_en; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_eenp_en ON public.evaluatedconversations_endocrinologist_np USING btree (is_assignment);


--
-- TOC entry 4374 (class 1259 OID 90568)
-- Name: idx_eh_diff; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_eh_diff ON public.evaluatedconversations_hospitality USING btree (difficulty);


--
-- TOC entry 4375 (class 1259 OID 90494)
-- Name: idx_eh_en; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_eh_en ON public.evaluatedconversations_hospitality USING btree (is_assignment);


--
-- TOC entry 4308 (class 1259 OID 90569)
-- Name: idx_ei_diff; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_ei_diff ON public.evaluatedconversations_itdecisionmaker USING btree (difficulty);


--
-- TOC entry 4309 (class 1259 OID 90489)
-- Name: idx_ei_en; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_ei_en ON public.evaluatedconversations_itdecisionmaker USING btree (is_assignment);


--
-- TOC entry 4341 (class 1259 OID 89744)
-- Name: idx_email_id; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_email_id ON public.users_tb USING btree (email_id);


--
-- TOC entry 4316 (class 1259 OID 90570)
-- Name: idx_eo_diff; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_eo_diff ON public.evaluatedconversations_oncologist USING btree (difficulty);


--
-- TOC entry 4317 (class 1259 OID 90495)
-- Name: idx_eo_en; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_eo_en ON public.evaluatedconversations_oncologist USING btree (is_assignment);


--
-- TOC entry 4301 (class 1259 OID 90571)
-- Name: idx_eom_diff; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_eom_diff ON public.evaluatedconversations_ophthalmologist_msl USING btree (difficulty);


--
-- TOC entry 4302 (class 1259 OID 90487)
-- Name: idx_eomsl_en; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_eomsl_en ON public.evaluatedconversations_ophthalmologist_msl USING btree (is_assignment);


--
-- TOC entry 4297 (class 1259 OID 90572)
-- Name: idx_eosr_diff; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_eosr_diff ON public.evaluatedconversations_ophthalmologist_sales_rep USING btree (difficulty);


--
-- TOC entry 4298 (class 1259 OID 90486)
-- Name: idx_eosr_en; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_eosr_en ON public.evaluatedconversations_ophthalmologist_sales_rep USING btree (is_assignment);


--
-- TOC entry 4338 (class 1259 OID 90559)
-- Name: idx_ep_ia; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_ep_ia ON public.evaluated_practice_tb USING btree (is_assignment);


--
-- TOC entry 4320 (class 1259 OID 90573)
-- Name: idx_er_diff; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_er_diff ON public.evaluatedconversations_retail USING btree (difficulty);


--
-- TOC entry 4321 (class 1259 OID 90491)
-- Name: idx_er_en; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_er_en ON public.evaluatedconversations_retail USING btree (is_assignment);


--
-- TOC entry 4333 (class 1259 OID 90558)
-- Name: idx_optb_ia; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_optb_ia ON public.ongoing_practice_tb USING btree (is_assignment);


--
-- TOC entry 4328 (class 1259 OID 89748)
-- Name: idx_prompt_id; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_prompt_id ON public.prompts2 USING btree (prompt_id);


--
-- TOC entry 4329 (class 1259 OID 90481)
-- Name: idx_promt_custid; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_promt_custid ON public.prompts2 USING btree (customer_id);


--
-- TOC entry 4330 (class 1259 OID 90560)
-- Name: idx_promt_custids; Type: INDEX; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE INDEX idx_promt_custids ON public.prompts2 USING btree (customer_id);


--
-- TOC entry 4399 (class 2620 OID 71602)
-- Name: taskstatus_blinded_daybue update_taskstatus_timestamp; Type: TRIGGER; Schema: public; Owner: a1sa0120vrtappshrd01u
--

CREATE TRIGGER update_taskstatus_timestamp BEFORE UPDATE ON public.taskstatus_blinded_daybue FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();


--
-- TOC entry 4392 (class 2606 OID 16463)
-- Name: evaluatedconversations_blinded_daybue evaluatedconversations_blinded_daybue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_blinded_daybue
    ADD CONSTRAINT evaluatedconversations_blinded_daybue_fkey FOREIGN KEY (prompt_id) REFERENCES public.prompts2(prompt_id);


--
-- TOC entry 4396 (class 2606 OID 68601)
-- Name: evaluatedconversations_blinded_daybue_mainstay2 evaluatedconversations_blinded_daybue_mainstay2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_blinded_daybue_mainstay2
    ADD CONSTRAINT evaluatedconversations_blinded_daybue_mainstay2_fkey FOREIGN KEY (prompt_id) REFERENCES public.prompts2(prompt_id);


--
-- TOC entry 4398 (class 2606 OID 72125)
-- Name: evaluatedconversations_coaching evaluatedconversations_coaching_fkey; Type: FK CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_coaching
    ADD CONSTRAINT evaluatedconversations_coaching_fkey FOREIGN KEY (prompt_id) REFERENCES public.prompts2(prompt_id);


--
-- TOC entry 4393 (class 2606 OID 16468)
-- Name: evaluatedconversations_dermatologist evaluatedconversations_dermatologist_fkey; Type: FK CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_dermatologist
    ADD CONSTRAINT evaluatedconversations_dermatologist_fkey FOREIGN KEY (prompt_id) REFERENCES public.prompts2(prompt_id);


--
-- TOC entry 4394 (class 2606 OID 16473)
-- Name: evaluatedconversations_endocrinologist_english evaluatedconversations_endocrinologist_english_fkey; Type: FK CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_endocrinologist_english
    ADD CONSTRAINT evaluatedconversations_endocrinologist_english_fkey FOREIGN KEY (prompt_id) REFERENCES public.prompts2(prompt_id);


--
-- TOC entry 4395 (class 2606 OID 16478)
-- Name: evaluatedconversations_endocrinologist_japanese evaluatedconversations_endocrinologist_japanese_fkey; Type: FK CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_endocrinologist_japanese
    ADD CONSTRAINT evaluatedconversations_endocrinologist_japanese_fkey FOREIGN KEY (prompt_id) REFERENCES public.prompts2(prompt_id);


--
-- TOC entry 4397 (class 2606 OID 72111)
-- Name: evaluatedconversations_hospitality evaluatedconversations_hospitality_fkey; Type: FK CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_hospitality
    ADD CONSTRAINT evaluatedconversations_hospitality_fkey FOREIGN KEY (prompt_id) REFERENCES public.prompts2(prompt_id);


--
-- TOC entry 4386 (class 2606 OID 16483)
-- Name: evaluatedconversations_itdecisionmaker evaluatedconversations_itdecisionmaker_fkey; Type: FK CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_itdecisionmaker
    ADD CONSTRAINT evaluatedconversations_itdecisionmaker_fkey FOREIGN KEY (prompt_id) REFERENCES public.prompts2(prompt_id);


--
-- TOC entry 4384 (class 2606 OID 16488)
-- Name: evaluatedconversations_ophthalmologist_msl evaluatedconversations_ophthalmologist_msl_fkey; Type: FK CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_ophthalmologist_msl
    ADD CONSTRAINT evaluatedconversations_ophthalmologist_msl_fkey FOREIGN KEY (prompt_id) REFERENCES public.prompts2(prompt_id);


--
-- TOC entry 4383 (class 2606 OID 16493)
-- Name: evaluatedconversations_ophthalmologist_sales_rep evaluatedconversations_ophthalmologist_sales_rep_fkey; Type: FK CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_ophthalmologist_sales_rep
    ADD CONSTRAINT evaluatedconversations_ophthalmologist_sales_rep_fkey FOREIGN KEY (prompt_id) REFERENCES public.prompts2(prompt_id);


--
-- TOC entry 4385 (class 2606 OID 16498)
-- Name: ongoingconversations_jp ongoingconversations_jp_prompt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.ongoingconversations_jp
    ADD CONSTRAINT ongoingconversations_jp_prompt_id_fkey FOREIGN KEY (prompt_id) REFERENCES public.prompts2(prompt_id);


--
-- TOC entry 4391 (class 2606 OID 16503)
-- Name: ongoingconversations ongoingconversations_prompt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.ongoingconversations
    ADD CONSTRAINT ongoingconversations_prompt_id_fkey FOREIGN KEY (prompt_id) REFERENCES public.prompts2(prompt_id);


--
-- TOC entry 4381 (class 2606 OID 16508)
-- Name: evaluatedconversations prompt_id; Type: FK CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations
    ADD CONSTRAINT prompt_id FOREIGN KEY (prompt_id) REFERENCES public.prompts2(prompt_id);


--
-- TOC entry 4387 (class 2606 OID 16513)
-- Name: evaluatedconversations_endocrinologist_np prompt_id; Type: FK CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_endocrinologist_np
    ADD CONSTRAINT prompt_id FOREIGN KEY (prompt_id) REFERENCES public.prompts2(prompt_id);


--
-- TOC entry 4382 (class 2606 OID 16518)
-- Name: evaluatedconversations_jp prompt_id; Type: FK CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_jp
    ADD CONSTRAINT prompt_id FOREIGN KEY (prompt_id) REFERENCES public.prompts2(prompt_id);


--
-- TOC entry 4388 (class 2606 OID 16523)
-- Name: evaluatedconversations_oncologist prompt_id; Type: FK CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_oncologist
    ADD CONSTRAINT prompt_id FOREIGN KEY (prompt_id) REFERENCES public.prompts2(prompt_id);


--
-- TOC entry 4389 (class 2606 OID 16528)
-- Name: evaluatedconversations_retail prompt_id; Type: FK CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.evaluatedconversations_retail
    ADD CONSTRAINT prompt_id FOREIGN KEY (prompt_id) REFERENCES public.prompts2(prompt_id);


--
-- TOC entry 4390 (class 2606 OID 16533)
-- Name: prompts2 prompts2_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.prompts2
    ADD CONSTRAINT prompts2_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer2(customer_id);


--
-- TOC entry 4380 (class 2606 OID 16538)
-- Name: prompts prompts_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: a1sa0120vrtappshrd01u
--

ALTER TABLE ONLY public.prompts
    ADD CONSTRAINT prompts_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- TOC entry 4544 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: rdsadmin
--

REVOKE ALL ON SCHEMA public FROM rdsadmin;
REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO a1s000aurpgsadmn;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2024-12-02 11:14:33

--
-- PostgreSQL database dump complete
--

