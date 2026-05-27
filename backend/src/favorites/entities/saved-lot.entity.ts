import {
  Column,
  CreateDateColumn,
  Entity,
  Index,
  PrimaryGeneratedColumn,
} from 'typeorm';

@Entity('saved_lots')
@Index(['userId', 'lotId'], { unique: true })
export class SavedLot {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ type: 'varchar' })
  userId!: string;

  @Column({ type: 'varchar' })
  lotId!: string;

  @Column({ type: 'varchar' })
  lotName!: string;

  @Column({ type: 'real' })
  lat!: number;

  @Column({ type: 'real' })
  lng!: number;

  @CreateDateColumn()
  createdAt!: Date;
}
