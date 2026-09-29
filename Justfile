build:
    swift build

test:
    swift test

clean:
    swift package clean

# Update the changelog
changelog:
    cz ch

# Bump the version from the commits since the last tag
bump: changelog
    cz bump
