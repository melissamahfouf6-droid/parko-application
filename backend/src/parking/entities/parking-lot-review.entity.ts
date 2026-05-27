import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity('parking_lot_reviews')
export class ParkingLotReview {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ type: 'varchar' })
  lotId!: string;

  @Column({ type: 'varchar' })
  userId!: string;

  @Column({ type: 'int' })
  stars!: number;

  @Column({ type: 'varchar', nullable: true })
  comment!: string | null;

  @CreateDateColumn()
  createdAt!: Date;
}
