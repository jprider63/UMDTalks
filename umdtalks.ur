table lists : {
	Id : int,
	Title : string,
	Details : string,
	Kind : string,
	Details_filter : string,
	(*Ex_directory : bool,*)
	Image_id : int,
	Created_at : time,
	Updated_at : time
}
	PRIMARY KEY Id

table talks : {
	Id : int,
	Title : string,
	Abstract : string,
	Special_message : string,
	Abstract_filtered : string,
	Start_time : time,
	End_time : time,
	Speaker_name : string,
	Speaker_id : int,
	Series_id : int,
	Venue_id : int,
	Created_at : time,
	Updated_at : time,
	Organiser_id : int,
	Image_id : int
}
	PRIMARY KEY Id

table users : {
	Id : int,
	Email : string,
	Alias : string,
	Password : string,
	Affiliation : string,
	Administrator : int,
	Last_login : time,
	Image_id : int,
	Created_at : time,
	Updated_at : time
}
	PRIMARY KEY Id

(* Organizations?? or just organizers. *)

style wrapper
style header
style content
style footer
style right
style left
style login
style box

fun unimplemented () = return <xml>
	<body>
		Unimplemented
	</body>
</xml>

fun search r = return <xml>
	<body>
		Unimplemented
	</body>
</xml>

fun template title sidebar body = (
	title' <- return (case title of
		| None => "UMDTalks"
		| Some t => t ^ " - UMDTalks"
	);
	return <xml>
		<head>
			<title>{[title']}</title>
			<link rel="stylesheet" type="text/css" href="/css/index.css" />
			<link rel="icon" href="/images/favicon.ico" />
		</head>
		<body>
			<div class={wrapper}>
				<div class={header}>
					<a link={index ()}><img src="/images/reallybigtalkslogo.gif" /></a>
					<div class={login}>
						<div class={box}>
							<div class={header}>
								Log in
							</div>
						</div>
					</div>
				</div>
				<div class={content}>
					<div class={left}>
						{sidebar}
					</div>
					<div class={right}>
						{body}
					</div>
				</div>
			</div>
			<div class={footer}>
				About | University of Maryland &copy; 2011
			</div>
		</body>
	</xml>
)

and index () = (
	sidebar <- return <xml>
		(*{searchBox ()}*)
		<div class={box}>
			<div class={header}>
				Featured Lists
			</div>
			<div class={content}>
				There are no featured lists at this time.
			</div>
		</div>
	</xml>;
	featTalks <- ( (*case hasRows (SELECT * FROM talks) of
		| True =>
			queryX ( SELECT * FROM talks) (fn r =>
				<xml>
					<div>
						{[r.Talks.Title]}
					</div>
				</xml>
			)
		| False => return
			<xml>
				No featured talks found.
			</xml>
*)

			queryX ( SELECT * FROM talks) (fn r =>
				<xml>
					<div>
						<a link={talk r.Talks.Id}>{[r.Talks.Title]}</a>
					</div>
				</xml>
			)



		);
	body <- return <xml>
		<div class={box}>
			<div class={header}>
				Featured Talks
			</div>
			<div class={content}>
				{featTalks}
			</div>
		</div>
	</xml>;
	template None sidebar body
)

and talk id =
	row <- oneOrNoRows (SELECT * FROM talks WHERE talks.Id = {[id]});
	( case row of
		| None =>
			sidebar <- return <xml>(*{searchBox ()}*)</xml>;
			body <- return <xml>
				<div class={box}>
					<div class={header}>
						Sorry!
					</div>
					<div class={content}>
						We could not find the talk you were looking for.
					</div>
				</div>
			</xml>;
			template (Some "Talk not found") sidebar body
		| Some r => 
			sidebar <- return <xml>
				<div class={box}>
					{[searchBox ()]}
					<div class={header}>
						Dashboard
					</div>
					<div class={content}>
						Add to list (*<select>
							<option>You have no lists</option>
						</select>*)
					</div>
				</div>
			</xml>;
			body <- return <xml>
				<div class={box}>
					<div class={header}>
						{[r.Talks.Title]}
					</div>
					<div class={content}>
						Abstract:
						<div>
							{[r.Talks.Abstract]}
						</div>
					</div>
				</div>
			</xml>;
			template (Some "Talk") sidebar body
	)

and searchBox () : transaction xbody =
	return <xml>
		<div class={box}>
			<div class={header}>
				Find a Talk
			</div>
			<div class={content}>
				<form>
					<textbox{#Query}/>
					<submit action={search} value="Search" />
				</form>
				<a link={unimplemented ()}>Advanced Search</a>
				<p>
				<a link={index ()}>Upcoming Talks</a><br />
				<a link={index ()}>Recently Added</a>
				</p>
			</div>
		</div>
	</xml>

(*
and featTalks () : xml =
	queryX ( SELECT * FROM talks) (fn r =>
		<xml>
			<div>
				{[r.Talks.Title]}
			</div>
		</xml>
	)
*)
