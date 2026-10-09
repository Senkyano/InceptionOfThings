PROJECTS = p1 p2 p3

up-%:
	$(MAKE) -C $* up

halt-%:
	$(MAKE) -C $* halt

clean-%:
	$(MAKE) -C $* clean

all-up:
	@for dir in $(PROJECTS); do $(MAKE) -C $$dir up; done

all-clean:
	@for dir in $(PROJECTS); do $(MAKE) -C $$dir clean; done