-- =========================
-- TURMAS
-- =========================
CREATE TABLE Turmas (
    id_turma SERIAL PRIMARY KEY,
    ano INTEGER NOT NULL,
    serie VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- DISCIPLINAS
-- =========================
CREATE TABLE Disciplinas (
    id_disciplina SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- PROFESSORES
-- =========================
CREATE TABLE Professores (
    id_professor SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- RELAÇÃO PROFESSORES ↔ DISCIPLINAS ↔ TURMAS
-- =========================
CREATE TABLE Professores_Disciplinas_Turmas (
    id SERIAL PRIMARY KEY,
    id_professor INTEGER NOT NULL REFERENCES Professores(id_professor) ON DELETE CASCADE,
    id_disciplina INTEGER NOT NULL REFERENCES Disciplinas(id_disciplina) ON DELETE CASCADE,
    id_turma INTEGER NOT NULL REFERENCES Turmas(id_turma) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- RELAÇÃO TURMAS ↔ DISCIPLINAS
-- =========================
CREATE TABLE Turmas_Disciplinas (
    id SERIAL PRIMARY KEY,
    id_turma INTEGER NOT NULL REFERENCES Turmas(id_turma) ON DELETE CASCADE,
    id_disciplina INTEGER NOT NULL REFERENCES Disciplinas(id_disciplina) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (id_turma, id_disciplina)
);

-- =========================
-- ALUNOS
-- =========================
CREATE TABLE Alunos (
    id_aluno SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    id_turma INTEGER REFERENCES Turmas(id_turma) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- NOTAS (com trimestre)
-- =========================
CREATE TABLE Notas (
    id SERIAL PRIMARY KEY,
    id_aluno INTEGER NOT NULL REFERENCES Alunos(id_aluno) ON DELETE CASCADE,
    id_turma_disciplina INTEGER NOT NULL REFERENCES Turmas_Disciplinas(id) ON DELETE CASCADE,
    id_disciplina INTEGER NOT NULL REFERENCES Disciplinas(id_disciplina) ON DELETE CASCADE,
    trimestre INTEGER NOT NULL DEFAULT 1,
    i1 NUMERIC(5,2),
    i2 NUMERIC(5,2),
    epa NUMERIC(5,2),
    n2 NUMERIC(5,2),
    n3 NUMERIC(5,2),
    rec NUMERIC(5,2),
    faltas INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_trimestre CHECK (trimestre IN (1, 2, 3))
);

-- =========================
-- RESPONSÁVEIS
-- =========================
CREATE TABLE Responsaveis (
    id_responsavel SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- RELAÇÃO ALUNOS ↔ RESPONSÁVEIS
-- =========================
CREATE TABLE Alunos_Responsaveis (
    id SERIAL PRIMARY KEY,
    id_aluno INTEGER NOT NULL REFERENCES Alunos(id_aluno) ON DELETE CASCADE,
    id_responsavel INTEGER NOT NULL REFERENCES Responsaveis(id_responsavel) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- COORDENAÇÃO
-- =========================
CREATE TABLE Coordenacao (
    id_coordenacao SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    codigo VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- ÍNDICES PARA PERFORMANCE
-- =========================
CREATE INDEX idx_notas_aluno ON Notas(id_aluno);
CREATE INDEX idx_notas_disciplina ON Notas(id_disciplina);
CREATE INDEX idx_notas_trimestre ON Notas(trimestre);

-- =========================
-- 🔹 INSERIR DADOS INICIAIS
-- =========================

-- TURMAS
INSERT INTO Turmas (ano, serie) VALUES
(1, 'A'),
(1, 'B'),
(2, 'A'),
(3, 'A');

-- DISCIPLINAS
INSERT INTO Disciplinas (nome) VALUES
('Matemática'),
('Português'),
('História'),
('Geografia'),
('Ciências');

-- RELAÇÃO TURMAS ↔ DISCIPLINAS
INSERT INTO Turmas_Disciplinas (id_turma, id_disciplina)
SELECT t.id_turma, d.id_disciplina
FROM Turmas t CROSS JOIN Disciplinas d;
