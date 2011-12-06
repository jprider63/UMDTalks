table entry : { Id : int, Sd : string}
	PRIMARY KEY Id

style header
style content
style box

(*
style wrapper
style header
style content
style footer
style right
style left
style login
style box
*)

(*
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
*)
fun index () = (*sidebar <- return <xml></xml>;*)
	sidebar <- return <xml><div>sidebar</div></xml>;
	Common.template (Some "test") sidebar
(*
	<head>
		<title>UMDTalks</title>
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
					<div class={box}>
						<div class={header}>
							Featured Lists
						</div>
						<div class={content}>
							A few lists...
						</div>
					</div>
				</div>
				<div class={right}>
					<div class={box}>
						<div class={header}>
							Featured Talks
						</div>
						<div class={content}>
							List a few talks...
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class={footer}>
			About | University of Maryland &copy; 2011
		</div>
	</body>
</xml>
*)
