class Node
  START_NODE_NAME = 'start'
  END_NODE_NAME = 'end'

  @@repository = []

  def self.for(node_name)
    @@repository.find { |node| node.name == node_name } || Node.new(node_name)
  end

  attr_reader :name
  attr_accessor :edges

  def add_edge(node)
    self.edges += [node]
    node.edges += [self] unless self.starting? || node.ending?

    self
  end

  def small?
    name == name.downcase
  end

  def large?
    name == name.upcase
  end

  def starting?
    name == START_NODE_NAME
  end

  def ending?
    name == END_NODE_NAME
  end

  def inspect
    name
  end

  private

  def initialize(node_name)
    @name = node_name
    @edges = []

    @@repository << self
  end
end

class Path
  MAX_SMALL_DUPLICATES = 1

  def initialize(*args)
    @nodes = *args
  end

  def leading_nodes
    *leading_nodes, _ = @nodes
    leading_nodes
  end

  def last_node
    *_, last_node = @nodes
    last_node
  end

  def for(*nodes)
    self.class.new(*(leading_nodes + nodes))
  end

  def valid?
    # Only one small node may occur twice in a path
    @nodes
      .select
      .with_index { |node, i| @nodes.index(node) != i }
      .select(&:small?)
      .size <= MAX_SMALL_DUPLICATES
  end
end

class PathFinder
  def initialize(edges)
    start_node = edges
                   .map { |edge| edge.split('-') }
                   .map { |node1, node2| Node.for(node1).add_edge(Node.for(node2)) }
                   .find(&:starting?)

    @paths = paths_from(paths: [Path.new(start_node)])
  end

  def distinct_valid_paths
    @paths.size
  end

  private

  def paths_from(paths:)
    possible_paths = paths.map do |path|
      next path if path.last_node.ending?

      possible_paths_from(path.last_node)
        .map { |edges| path.for(*edges) }
        .select(&:valid?)
    end.flatten

    return possible_paths if possible_paths == paths

    paths_from(paths: possible_paths)
  end

  def possible_paths_from(node)
    node.edges.map { |edge| [node, edge] }
  end
end

p(
  PathFinder.new(File.readlines('input.txt', chomp: true))
    .distinct_valid_paths
)
