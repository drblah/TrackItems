--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.5
-- Dumped by pg_dump version 9.4.0
-- Started on 2015-12-14 14:35:25 CET

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 173 (class 3079 OID 11861)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2017 (class 0 OID 0)
-- Dependencies: 173
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 192 (class 1255 OID 16406)
-- Name: change_name(macaddr, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION change_name("BtAddr" macaddr, "NewName" text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	result integer;

BEGIN
	result := 1;
	UPDATE "Devices"
	SET  "DeviceName"="NewName"
	WHERE "Devices"."BluetoothAddr"="BtAddr";

	RETURN result;
END;
  $$;


ALTER FUNCTION public.change_name("BtAddr" macaddr, "NewName" text) OWNER TO postgres;

--
-- TOC entry 191 (class 1255 OID 16425)
-- Name: delete_device(macaddr); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION delete_device(addr macaddr) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	result integer;

BEGIN
	result := 1;
	DELETE FROM "Devices"
	WHERE "Devices"."BluetoothAddr" = addr;

	RETURN result;
END;
  $$;


ALTER FUNCTION public.delete_device(addr macaddr) OWNER TO postgres;

--
-- TOC entry 193 (class 1255 OID 16412)
-- Name: make_new_device(macaddr, text, smallint, point); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION make_new_device("BluetoothAddr" macaddr, "DeviceName" text, "SignalStrength" smallint DEFAULT NULL::smallint, "Location" point DEFAULT NULL::point) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	result integer;

BEGIN
	result := 1;
	INSERT INTO public."Devices"("BluetoothAddr","DeviceName","SignalStrength","Location")
	VALUES ("BluetoothAddr", "DeviceName", "SignalStrength", "Location"); 
	RETURN result;
END;
  $$;


ALTER FUNCTION public.make_new_device("BluetoothAddr" macaddr, "DeviceName" text, "SignalStrength" smallint, "Location" point) OWNER TO postgres;

--
-- TOC entry 186 (class 1255 OID 16414)
-- Name: select_all_devices(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION select_all_devices() RETURNS TABLE("BluetoothAddr" macaddr, "DeviceName" text, "SignalStrength" smallint, "Location" point, "LastSeen" timestamp with time zone, "TimeAdded" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$

BEGIN
	RETURN QUERY
		SELECT * FROM "Devices";
END;
$$;


ALTER FUNCTION public.select_all_devices() OWNER TO postgres;

--
-- TOC entry 194 (class 1255 OID 16415)
-- Name: select_device_by_adress(macaddr); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION select_device_by_adress(btaddr macaddr) RETURNS TABLE("BluetoothAddr" macaddr, "DeviceName" text, "SignalStrength" smallint, "Location" point, "LastSeen" timestamp with time zone, "TimeAdded" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$

BEGIN
	RETURN QUERY
		SELECT * 
		FROM public."Devices"
		WHERE "Devices"."BluetoothAddr" = btaddr;
END;
$$;


ALTER FUNCTION public.select_device_by_adress(btaddr macaddr) OWNER TO postgres;

--
-- TOC entry 195 (class 1255 OID 16416)
-- Name: select_device_by_name(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION select_device_by_name(dname text) RETURNS TABLE("BluetoothAddr" macaddr, "DeviceName" text, "SignalStrength" smallint, "Location" point, "LastSeen" timestamp with time zone, "TimeAdded" timestamp with time zone)
    LANGUAGE plpgsql
    AS $$

BEGIN
	RETURN QUERY
		SELECT * 
		FROM public."Devices"
		WHERE "Devices"."DeviceName" = dname;
END;
$$;


ALTER FUNCTION public.select_device_by_name(dname text) OWNER TO postgres;

--
-- TOC entry 190 (class 1255 OID 16417)
-- Name: select_devices_name_and_addr_only(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION select_devices_name_and_addr_only() RETURNS TABLE("BluetoothAddr" macaddr, "DeviceName" text)
    LANGUAGE plpgsql
    AS $$

BEGIN
	RETURN QUERY
		SELECT "Devices"."BluetoothAddr","Devices"."DeviceName" FROM "Devices";
END;
$$;


ALTER FUNCTION public.select_devices_name_and_addr_only() OWNER TO postgres;

--
-- TOC entry 188 (class 1255 OID 16410)
-- Name: update_lastseen(macaddr); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_lastseen("BtAddr" macaddr) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	result integer;

BEGIN
	result := 1;
	UPDATE "Devices"
	SET  "LastSeen"=now()
	WHERE "Devices"."BluetoothAddr"="BtAddr";

	RETURN result;
END;
  $$;


ALTER FUNCTION public.update_lastseen("BtAddr" macaddr) OWNER TO postgres;

--
-- TOC entry 187 (class 1255 OID 16409)
-- Name: update_location(macaddr, point); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_location("BtAddr" macaddr, "NewLocation" point) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	result integer;

BEGIN
	result := 1;
	UPDATE "Devices"
	SET  "Location"="NewLocation"
	WHERE "Devices"."BluetoothAddr"="BtAddr";

	RETURN result;
END;
  $$;


ALTER FUNCTION public.update_location("BtAddr" macaddr, "NewLocation" point) OWNER TO postgres;

--
-- TOC entry 189 (class 1255 OID 16411)
-- Name: update_signal_strength(macaddr, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_signal_strength("BtAddr" macaddr, "sigStr" smallint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	result integer;

BEGIN
	result := 1;
	UPDATE "Devices"
	SET  "SignalStrenght"="sigStr"
	WHERE "Devices"."BluetoothAddr"="BtAddr";

	RETURN result;
END;
  $$;


ALTER FUNCTION public.update_signal_strength("BtAddr" macaddr, "sigStr" smallint) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 172 (class 1259 OID 16385)
-- Name: Devices; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE "Devices" (
    "BluetoothAddr" macaddr NOT NULL,
    "DeviceName" text NOT NULL,
    "SignalStrength" smallint,
    "Location" point,
    "LastSeen" timestamp with time zone,
    "TimeAdded" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE "Devices" OWNER TO postgres;

--
-- TOC entry 2009 (class 0 OID 16385)
-- Dependencies: 172
-- Data for Name: Devices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Devices" ("BluetoothAddr", "DeviceName", "SignalStrength", "Location", "LastSeen", "TimeAdded") FROM stdin;
ca:ca:a1:fa:c5:dd	beeperTing	\N	(57.0528096669999982,9.91149099999999983)	2015-12-09 13:04:26.708576+00	2015-12-09 09:32:15.553935+00
ca:12:82:49:54:eb	Lars	\N	(57.0528981670000022,9.91133516700000072)	2015-12-09 13:03:44.046691+00	2015-12-09 09:37:44.465878+00
\.


--
-- TOC entry 1897 (class 2606 OID 16408)
-- Name: DeviceName; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "Devices"
    ADD CONSTRAINT "DeviceName" UNIQUE ("DeviceName");


--
-- TOC entry 1899 (class 2606 OID 16393)
-- Name: PKBluetoothAddr; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "Devices"
    ADD CONSTRAINT "PKBluetoothAddr" PRIMARY KEY ("BluetoothAddr");


--
-- TOC entry 2016 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
GRANT USAGE ON SCHEMA public TO lookielookie;


--
-- TOC entry 2018 (class 0 OID 0)
-- Dependencies: 172
-- Name: Devices; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE "Devices" FROM PUBLIC;
REVOKE ALL ON TABLE "Devices" FROM postgres;
GRANT ALL ON TABLE "Devices" TO postgres;
GRANT ALL ON TABLE "Devices" TO lookielookie;


--
-- TOC entry 1557 (class 826 OID 16397)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres REVOKE ALL ON TABLES  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres REVOKE ALL ON TABLES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES  TO PUBLIC;


-- Completed on 2015-12-14 14:35:26 CET

--
-- PostgreSQL database dump complete
--

